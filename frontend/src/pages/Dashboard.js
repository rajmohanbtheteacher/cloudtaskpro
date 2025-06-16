import React, { useState, useEffect } from 'react';
import axios from '../axios';
import { useNavigate } from 'react-router-dom';

export default function Dashboard() {
  const [tasks, setTasks] = useState([]);
  const [task, setTask] = useState('');
  const navigate = useNavigate();

  const fetchTasks = async () => {
    try {
      const token = localStorage.getItem('token');
      const res = await axios.get('/tasks', {
        headers: { Authorization: `Bearer ${token}` }
      });
      setTasks(res.data);
    } catch (err) {
      navigate('/');
    }
  };

  const createTask = async () => {
    try {
      const token = localStorage.getItem('token');
      await axios.post('/tasks', { title: task }, {
        headers: { Authorization: `Bearer ${token}` }
      });
      setTask('');
      fetchTasks();
    } catch (err) {
      console.error(err);
    }
  };

  useEffect(() => {
    fetchTasks();
  }, []);

  return (
    <div className="min-h-screen bg-black/40 text-white p-10">
      <div className="max-w-2xl mx-auto backdrop-blur-lg bg-white/10 border border-white/20 rounded-2xl p-6">
        <h1 className="text-3xl font-bold mb-4">Your Tasks</h1>
        <div className="mb-6">
          <input
            className="w-full p-2 rounded mb-2 text-black"
            placeholder="Enter a new task"
            value={task}
            onChange={(e) => setTask(e.target.value)}
          />
          <button onClick={createTask} className="bg-blue-600 px-4 py-2 rounded text-white w-full">Add Task</button>
        </div>
        <ul className="list-disc list-inside space-y-2">
          {tasks.map((t, index) => (
            <li key={index} className="bg-white/10 px-4 py-2 rounded">{t.title}</li>
          ))}
        </ul>
      </div>
    </div>
  );
}
