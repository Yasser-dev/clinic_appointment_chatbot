const functions = require("firebase-functions");
const { WebhookClient } = require("dialogflow-fulfillment");
const { google } = require("googleapis");

process.env.DEBUG = "dialogflow:debug"; // enables lib debugging statements

const calendarId = "CALENDAR ID HERE";
const serviceAccount = {}; // GCP Service Account Json info

// Set up Google Calendar Service account credentials
const serviceAccountAuth = new google.auth.JWT({
  email: serviceAccount.client_email,
  key: serviceAccount.private_key,
  scopes: "https://www.googleapis.com/auth/calendar",
});

const calendar = google.calendar("v3");

const timeZone = "Asia/Singapore";
const timeZoneOffset = "+08:00";

exports.dialogflowFirebaseFulfillment = functions.https.onRequest(
  (request, response) => {
    const agent = new WebhookClient({ request, response });
    console.log(
      "Dialogflow Request headers: " + JSON.stringify(request.headers)
    );
    console.log("Dialogflow Request body: " + JSON.stringify(request.body));

    function proceedToConfirmation(agent) {
      const params = agent.parameters;
      const contextParams = agent.getContext(
        "waiting_appointment_details"
      ).parameters;
      const { name, number, email } = params;
      const { date, time } = contextParams;
      const parsedDate = `${date.toString().split("T")[0]}T${
        time.toString().split("T")[1].split("+")[0].split("-")[0]
      }${timeZoneOffset}`;

      const aptDateTime = new Date(parsedDate);
      const appointmentTimeString = aptDateTime.toLocaleString("en-US", {
        month: "short",
        day: "numeric",
        year: "numeric",
        hour: "numeric",
        timeZoneName: "short",
        timeZone: timeZone,
      });
    
      agent.add(
`Thanks! Please reply with "Yes" if the following info is correct:
Name: ${name}
Phone Number: ${number}
Email: ${email}
Appointment Time: ${appointmentTimeString}
______
If you want to re enter the info reply with "No"`
      );
    }

    function onConfirmResponse(agent) {
      const confirmed = agent.parameters.confirmed;
      if (confirmed === "false") {
        agent.add("Sure, please enter a new appointment date and time again!");
        agent.setContext({
          name: "waiting_appointment_details",
          lifespan: 5,
        });
        return;
      } else if (confirmed === "true") {
        const { date, time } = agent.getContext(
          "waiting_appointment_details"
        ).parameters;
        const { name, number, email } =
          agent.getContext("waiting_contact").parameters;
        const parsedDate = `${date.toString().split("T")[0]}T${
          time.toString().split("T")[1].split("+")[0].split("-")[0]
        }${timeZoneOffset}`;
        const dateTimeStart = new Date(parsedDate);
        const dateTimeEnd = new Date(
          new Date(dateTimeStart).setHours(dateTimeStart.getHours() + 1)
        );
        const appointmentTimeString = dateTimeStart.toLocaleString("en-US", {
          month: "short",
          day: "numeric",
          year: "numeric",
          hour: "numeric",
          timeZoneName: "short",
          timeZone: timeZone,
        });

        return createCalendarEvent(
          dateTimeStart,
          dateTimeEnd,
          name,
          number,
          email
        )
          .then(() => {
            agent.add(
              `Appointment booked for ${appointmentTimeString}, See you soon!`
            );
          })
          .catch(() => {
            agent.add(
              `I'm sorry, there are no slots available for ${appointmentTimeString}. Please re-enter the info`
            );
            agent.setContext({
              name: "waiting_appointment_details",
              lifespan: 5,
            });
          });
      }
    }

    let intentMap = new Map();
    intentMap.set("Get Contact", proceedToConfirmation);
    intentMap.set("Get Confirmation", onConfirmResponse);
    agent.handleRequest(intentMap);
  }
);

//Creates calendar event in Google Calendar
function createCalendarEvent(dateTimeStart, dateTimeEnd, name, number, email) {
  return new Promise((resolve, reject) => {
    calendar.events.list(
      {
        auth: serviceAccountAuth, // List events for time period
        calendarId: calendarId,
        timeMin: dateTimeStart.toISOString(),
        timeMax: dateTimeEnd.toISOString(),
      },
      (err, calendarResponse) => {
        // Check if there is a event already on the Calendar
        if (err || calendarResponse.data.items.length > 0) {
          reject(
            err ||
              new Error("Requested time conflicts with another appointment")
          );
        } else {
          // Create event for the requested time period
          calendar.events.insert(
            {
              auth: serviceAccountAuth,
              calendarId: calendarId,
              resource: {
                summary: `Clinic Appointment - ${name}`,
                description: `${name} - ${number} - ${email}`,
                start: { dateTime: dateTimeStart },
                end: { dateTime: dateTimeEnd },
              },
            },
            (err, event) => {
              if (err) {
                reject(err);
              } else {
                resolve(event);
              }
            }
          );
        }
      }
    );
  });
}
