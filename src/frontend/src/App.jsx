import { AuthClient } from '@dfinity/auth-client';
import { createActor } from './declarations/backend';
import { canisterId } from './declarations/backend/index.js';
import React, { useState, useEffect } from 'react';
import '../index.css';

const network = process.env.DFX_NETWORK;
const identityProvider =
  network === 'ic'
    ? 'https://identity.ic0.app' // Mainnet
    : 'https://identity.internetcomputer.org'; // Local

function App() {
  const [isAuthenticated, setIsAuthenticated] = useState(false);
  const [authClient, setAuthClient] = useState();
  const [actor, setActor] = useState();
  // const [files, setFiles] = useState([]);
  const [errorMessage, setErrorMessage] = useState();
  const [fileTransferProgress, setFileTransferProgress] = useState();

  useEffect(() => {
    updateActor();
    setErrorMessage();
  }, []);

  useEffect(() => {
    if (isAuthenticated) {
      // loadFiles();
    }
  }, [isAuthenticated]);

  async function updateActor() {
    const authClient = await AuthClient.create();
    const identity = authClient.getIdentity();
    const actor = createActor(canisterId, {
      agentOptions: {
        identity
      }
    });
    const isAuthenticated = await authClient.isAuthenticated();

    setActor(actor);
    setAuthClient(authClient);
    setIsAuthenticated(isAuthenticated);
  }

  async function login() {
    await authClient.login({
      identityProvider,
      onSuccess: updateActor
    });
  }

  async function logout() {
    await authClient.logout();
    updateActor();
  }

  async function initiateUserData(event, id) {
    event.preventDefault()
    try {
      const userData = await actor.initiateUserData(event.value.userNumber);
      console.log(userData)
    } catch (error) {
    }
  }

  return (
    <div className="container mx-auto p-4">
      <div className="flex flex-row justify-between">
        <h1 className="mb-4 text-2xl font-bold"><img src="/assets/logo-dark.png" /></h1>

        {isAuthenticated ? (
          <button onClick={logout} className="rounded bg-blue-500 px-4 py-2 text-white hover:bg-blue-600">
            Logout
          </button>
        ) : (
          <button onClick={login} className="rounded bg-blue-500 px-4 py-2 text-white hover:bg-blue-600">
            Login with Internet Identity
          </button>
        )}
      </div>

      {!isAuthenticated ? (
        <>
          <div className="mt-4 rounded-md border-l-4 bg-neutral-200 p-4 shadow-md">
            <p className="mt-2 text-black">Please login to redeem your cash aid</p>
          </div>
        </>
      ) : (
        <div>
          {errorMessage && (
            <div className="mt-4 rounded-md border border-red-400 bg-red-100 p-3 text-red-700">{errorMessage}</div>
          )}
          <div className="max-w-7xl mx-auto">
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
              <div className="bg-white shadow-md rounded-lg p-6">
                <h2 className="text-2xl font-bold mb-4 text-gray-800">Initiate UserData</h2>
                <form id="profileForm" className="space-y-4" onSubmit={initiateUserData}>
                  <div>
                    <label for="userNumber" className="block text-sm font-medium text-gray-700">User Number</label>
                    <input type="text" id="userNumber" name="userNumber" required
                      className="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm" />
                  </div>
                  <div>
                    <button type="submit"
                      className="w-full flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
                      Submit
                    </button>
                  </div>
                </form>
              </div>
              <div className="bg-white shadow-md rounded-lg p-6">
                <h2 className="text-2xl font-bold mb-4 text-gray-800">Current Balance</h2>
                <p id="balanceDisplay" className="text-4xl font-bold text-green-600">PHP0.00</p>
                <p id="balanceMessage" className="mt-2 text-gray-600">Submit your information to view your balance</p>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}

export default App;
