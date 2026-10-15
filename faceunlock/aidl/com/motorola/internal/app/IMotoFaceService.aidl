package com.motorola.internal.app;

import com.motorola.internal.app.IMotoFaceServiceReceiver;

/** Stub of the Motorola face unlock service interface (signatures from the calls in FaceService.java). */
interface IMotoFaceService {
    void setCallback(IMotoFaceServiceReceiver receiver);
    void authenticate(long operationId);
    void cancel();
    void remove(int faceId);
    void enumerate();
    void enroll(in byte[] cryptoToken, int timeout, in int[] disabledFeatures);
    void resetLockout(in byte[] cryptoToken);
    long getAuthenticatorId();
    long generateChallenge(int timeoutSec);
    int revokeChallenge();
}
