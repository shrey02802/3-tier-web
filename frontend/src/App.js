import React, { useEffect, useState } from "react";
import { getMessages, postMessage } from "./api";

function App() {
  const [messages, setMessages] = useState([]);
  const [text, setText] = useState("");

useEffect(() => {
  loadMessages();
}, []);

const loadMessages = async () => {
  try {
    const res = await getMessages();
    setMessages(res.data);
  } catch (e) {
    console.error(e);
  }
};


  const submit = async (ev) => {
    ev.preventDefault();
    if (!text) return;
    try {
      await postMessage(text);
      setText("");
      loadMessages();

    } catch (e) {
      console.error(e);
    }
  };

  return (
    <div style={{ padding: 40 }}>
      <h1>3-Tier Message Board</h1>

      <form onSubmit={submit}>
        <input value={text} onChange={e => setText(e.target.value)} placeholder="write a message" style={{ width: 400 }} />
        <button type="submit">Send</button>
      </form>

      <h2>Messages</h2>
      <ul>
        {messages.map(m => (
          <li key={m.id}><strong>{new Date(m.created_at).toLocaleString()}:</strong> {m.text}</li>
        ))}
      </ul>
    </div>
  );
}

export default App;
