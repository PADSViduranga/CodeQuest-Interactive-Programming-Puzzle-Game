const { onCall } = require('firebase-functions/v2/https');

// Placeholder to prove the functions project runs. Real functions come next.
exports.ping = onCall(() => ({ ok: true }));
