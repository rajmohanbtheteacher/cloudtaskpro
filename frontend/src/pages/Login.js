import React, { useState } from 'react';
import axios from '../axios';
import { useNavigate } from 'react-router-dom';

export default function Login() {
  const navigate = useNavigate();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');

  const handleLogin = async (e) => {
    e.preventDefault();
    try {
      const res = await axios.post('/login', { email, password });
      localStorage.setItem('token', res.data.token);
      navigate('/dashboard');
    } catch (err) {
      setError('Invalid credentials');
    }
  };

  return (
    <div className="h-screen flex items-center justify-center text-white">
      <div className="backdrop-blur-md bg-white/10 border border-white/20 shadow-lg rounded-2xl p-10 w-full max-w-md">
        <h1 className="text-3xl font-bold mb-6 text-center">Login to CloudTaskPro</h1>
        <form onSubmit={handleLogin} className="space-y-4">
          <input value={email} onChange={(e) => setEmail(e.target.value)} type="email" placeholder="Email" className="w-full p-2 rounded bg-white/20 text-white border border-white/30 placeholder-white/80" />
          <input value={password} onChange={(e) => setPassword(e.target.value)} type="password" placeholder="Password" className="w-full p-2 rounded bg-white/20 text-white border border-white/30 placeholder-white/80" />
          <button className="w-full bg-blue-500 hover:bg-blue-600 text-white p-2 rounded">Login</button>
        </form>
        {error && <p className="mt-2 text-red-400 text-center">{error}</p>}
      </div>
    </div>
  );
}
