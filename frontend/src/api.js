import axios from "axios";

const API = axios.create({
  baseURL: process.env.REACT_APP_API_URL
});

// Fetch all messages
export const getMessages = () => API.get("/api/messages");

// Send a new message
export const postMessage = (text) => API.post("/api/messages", { text });


