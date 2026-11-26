/**
 * Runs Python code in the Judge0 sandbox (https://ce.judge0.com).
 * Set JUDGE0_URL and JUDGE0_TOKEN (optional) to use another Judge0 server.
 */
const BASE = (process.env.JUDGE0_URL || 'https://ce.judge0.com').replace(/\/$/, '');

function headers() {
  const h = { 'Content-Type': 'application/json' };
  if (process.env.JUDGE0_TOKEN) h['X-Auth-Token'] = process.env.JUDGE0_TOKEN;
  return h;
}

let languageIdPromise;

/** Finds the newest "Python (3.x...)" id, so we never hard-code a version. */
function pythonLanguageId() {
  if (!languageIdPromise) {
    languageIdPromise = fetch(`${BASE}/languages`, { headers: headers() })
      .then((r) => {
        if (!r.ok) throw new Error(`languages ${r.status}`);
        return r.json();
      })
      .then((list) => {
        const py = list
          .filter((l) => /^Python \(3/.test(l.name))
          .sort((a, b) => b.id - a.id);
        if (!py.length) throw new Error('No Python language on the Judge0 server');
        return py[0].id;
      })
      .catch((e) => {
        languageIdPromise = undefined; // try again next time
        throw e;
      });
  }
  return languageIdPromise;
}

/** Runs one program with the given input. Returns { stdout, stderr, compileOutput, status }. */
async function runPython(sourceCode, stdin) {
  const languageId = await pythonLanguageId();
  const res = await fetch(`${BASE}/submissions?base64_encoded=false&wait=true`, {
    method: 'POST',
    headers: headers(),
    body: JSON.stringify({
      language_id: languageId,
      source_code: sourceCode,
      stdin: stdin || '',
      cpu_time_limit: 3,
      memory_limit: 128000,
    }),
  });
  if (!res.ok) throw new Error(`submissions ${res.status}`);
  const data = await res.json();
  return {
    stdout: data.stdout || '',
    stderr: data.stderr || '',
    compileOutput: data.compile_output || '',
    status: data.status ? data.status.id : 0,
  };
}

module.exports = { runPython };
