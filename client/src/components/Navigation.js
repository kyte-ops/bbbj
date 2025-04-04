import React from 'react';
import { NavLink } from 'react-router-dom';
import { FaHome, FaCalendarAlt, FaUser } from 'react-icons/fa';

function Navigation() {
  return (
    <nav className="fixed bottom-0 left-0 right-0 bg-white shadow-lg border-t border-gray-200">
      <div className="container mx-auto px-4">
        <ul className="flex justify-around items-center h-16">
          <li>
            <NavLink 
              to="/home" 
              className={({ isActive }) => 
                `flex flex-col items-center ${isActive ? 'text-blue-600' : 'text-gray-500'} hover:text-blue-600 transition-colors`
              }
            >
              <FaHome className="text-2xl" />
              <span className="text-xs mt-1">Home</span>
            </NavLink>
          </li>
          <li>
            <NavLink 
              to="/study" 
              className={({ isActive }) => 
                `flex flex-col items-center ${isActive ? 'text-blue-600' : 'text-gray-500'} hover:text-blue-600 transition-colors`
              }
            >
              <FaCalendarAlt className="text-2xl" />
              <span className="text-xs mt-1">Study</span>
            </NavLink>
          </li>
          <li>
            <NavLink 
              to="/profile" 
              className={({ isActive }) => 
                `flex flex-col items-center ${isActive ? 'text-blue-600' : 'text-gray-500'} hover:text-blue-600 transition-colors`
              }
            >
              <FaUser className="text-2xl" />
              <span className="text-xs mt-1">Profile</span>
            </NavLink>
          </li>
        </ul>
      </div>
    </nav>
  );
}

export default Navigation;
