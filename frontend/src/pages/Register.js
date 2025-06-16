import React, { useState } from 'react';
import axios from '../axios';
import { useNavigate } from 'react-router-dom';

export default function Register() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [message, setMessage] = useState('');
  const navigate = useNavigate();

  const handleRegister = async (e) => {
    e.preventDefault();
    try {
      await axios.post('/register', { email, password });
      setMessage("Registered successfully. Please login.");
      setTimeout(() => navigate('/'), 2000);
    } catch (err) {
      setMessage("Registration failed.");
    }
  };

  return (
    <div className="h-screen flex items-center justify-center text-white">
      <div className="backdrop-blur-md bg-white/10 border border-white/20 shadow-lg rounded-2xl p-10 w-full max-w-md">
        <h1 className="text-3xl font-bold mb-6 text-center">Register to CloudTaskPro</h1>
        <form onSubmit={handleRegister} className="space-y-4">
          <input value={email} onChange={(e) => setEmail(e.target.value)} type="email" placeholder="Email" className="w-full p-2 rounded bg-white/20 text-white border border-white/30 placeholder-white/80" />
          <input value={password} onChange={(e) => setPassword(e.target.value)} type="password" placeholder="Password" className="w-full p-2 rounded bg-white/20 text-white border border-white/30 placeholder-white/80" />
          <button className="w-full bg-green-500 hover:bg-green-600 text-white p-2 rounded">Register</button>
        </form>
        {message && <p className="mt-4 text-center">{message}</p>}
      </div>
    </div>
  );
}
