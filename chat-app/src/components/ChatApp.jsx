import React, { useState } from "react";
import axios from "axios";
import { Box, Button, TextField, CircularProgress, Typography, Paper } from "@mui/material";

const ChatApp = () => {
  const [question, setQuestion] = useState("");
  const [jobs, setJobs] = useState([]); // Each job: { job_id, question, response, status }

  const sendQuestion = async () => {
    if (!question.trim()) return;

    try {
      // Call /chat API
      const res = await axios.post("http://localhost:8080/chat", {
        text: question,
        priority: "normal"
      });

      const newJob = {
        job_id: res.data.job_id,
        question,
        response: "",
        status: "queued"
      };

      setJobs((prev) => [newJob, ...prev]);
      setQuestion("");

      // Start polling
      pollResult(newJob.job_id);
    } catch (err) {
      console.error(err);
      alert("Error sending question. Check console.");
    }
  };

  const pollResult = (job_id) => {
    const interval = setInterval(async () => {
      try {
        const res = await axios.get(`http://localhost:8080/result/${job_id}`);
        setJobs((prev) =>
          prev.map((job) =>
            job.job_id === job_id
              ? {
                  ...job,
                  response: res.data.response || "",
                  status: res.data.status
                }
              : job
          )
        );

        if (res.data.status === "done") clearInterval(interval);
      } catch (err) {
        console.error(err);
      }
    }, 2000); // Poll every 2 seconds
  };

  return (
    <Box sx={{ maxWidth: 600, margin: "20px auto", padding: 2 }}>
      <Typography variant="h4" align="center" gutterBottom>
        Chat with API
      </Typography>

      <Box sx={{ display: "flex", gap: 1, mb: 2 }}>
        <TextField
          fullWidth
          label="Type your question"
          value={question}
          onChange={(e) => setQuestion(e.target.value)}
        />
        <Button variant="contained" onClick={sendQuestion}>
          Send
        </Button>
      </Box>

      <Box sx={{ display: "flex", flexDirection: "column", gap: 2 }}>
        {jobs.map((job) => (
          <Paper key={job.job_id} sx={{ p: 2 }} elevation={2}>
            <Typography variant="subtitle1" color="primary">
              You: {job.question}
            </Typography>
            <Typography variant="body1" sx={{ mt: 1 }}>
              Bot:{" "}
              {job.status === "done" ? (
                job.response
              ) : (
                <CircularProgress size={20} sx={{ verticalAlign: "middle" }} />
              )}
            </Typography>
          </Paper>
        ))}
      </Box>
    </Box>
  );
};

export default ChatApp;
