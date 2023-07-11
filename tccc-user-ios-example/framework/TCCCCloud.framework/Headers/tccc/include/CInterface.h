#pragma once
#include <stdint.h>
#include "TCCCTypeDef.h"

#ifdef _WIN32
#  if !defined(__cplusplus)
#    define TCCCUSER_API extern __declspec(dllexport)
#  else
#    define TCCCUSER_API extern "C" __declspec(dllexport)
#  endif
#  define TCCCUSER_CALL __cdecl
#else
#  define TCCCUSER_API extern "C"
#  define TCCCUSER_CALL __cdecl
#endif

extern "C" {
// 通用回调
typedef void (*TCCCUSER_CALL TCCC_OnErrorHandler)(int err_code, const char* err_msg, void* extra_info);
typedef void (*TCCCUSER_CALL TCCC_OnWarningHandler)(int warning_code, const char* warning_msg, void* extra_info);
typedef void (*TCCCUSER_CALL TCCC_OnNewSessionHandler)(const char* sessionId, int sessionDirection,
                                                       const char* toUserId, const char* fromUserId);
typedef void (*TCCCUSER_CALL TCCC_OnEndedHandler)(int reason, const char* reasonMessage, const char* sessionId);
typedef void (*TCCCUSER_CALL TCCC_OnAcceptedHandler)(const char* sessionId);
typedef void (*TCCCUSER_CALL TCCC_OnAudioVolumeHandler)(const char* userId, uint32_t volume);
// remoteUserId 为null的时候，remoteQuality是没有意义的
typedef void (*TCCCUSER_CALL TCCC_OnNetworkQualityHandler)(const char* localUserId, int localQuality,
                                                           const char* remoteUserId, int remoteQuality,
                                                           uint32_t remoteQualityCount);

typedef void (*TCCCUSER_CALL TCCC_OnConnectionLost)(int serverType);
typedef void (*TCCCUSER_CALL TCCC_OnTryToReconnect)(int serverType);
typedef void (*TCCCUSER_CALL TCCC_OnConnectionRecovery)(int serverType);

// 登录&呼叫相关的回调
typedef void (*TCCCUSER_CALL TCCC_OnLoginHandler)(int err_code, const char* err_msg, const char* userId,
                                                  const char* userAor, const char* otherInfo);
typedef void (*TCCCUSER_CALL TCCC_OnLogoutHandler)(int err_code, const char* err_msg);
typedef void (*TCCCUSER_CALL TCCC_OnStartCallHandler)(int err_code, const char* err_msg);
typedef void (*TCCCUSER_CALL TCCC_OnAnswerHandler)(int err_code, const char* err_msg);
typedef void (*TCCCUSER_CALL TCCC_OnCheckLoginHandler)(int err_code, const char* err_msg);
typedef void (*TCCCUSER_CALL TCCC_OnSendDTMFHandler)(int err_code, const char* err_msg);
}
// 参数只有Android需要，其他可以直接用null
TCCCUSER_API void* TCCC_GetTCCCInstance(void* context);
TCCCUSER_API void TCCC_DestroyTCCCInstance();

TCCCUSER_API void TCCC_AddCallback(TCCC_OnErrorHandler onError, TCCC_OnWarningHandler onWarning,
                                   TCCC_OnNewSessionHandler onNewSession, TCCC_OnEndedHandler onEnded,
                                   TCCC_OnAcceptedHandler onAccepted, TCCC_OnAudioVolumeHandler onAudioVolume,
                                   TCCC_OnNetworkQualityHandler onNetworkQuality,
                                   TCCC_OnConnectionLost onConnectionLost, TCCC_OnTryToReconnect onTryToReconnect,
                                   TCCC_OnConnectionRecovery onConnectionRecovery);
TCCCUSER_API void TCCC_RemoveCallback();
TCCCUSER_API void TCCC_ResetSip(bool isNeedCallReLogin);
TCCCUSER_API void TCCC_Call(const tccc::TCCCStartCallParams& param, TCCC_OnStartCallHandler callback);
TCCCUSER_API void TCCC_OneClickCall(const tccc::TCCCCallParams& param, TCCC_OnStartCallHandler callback);
TCCCUSER_API void TCCC_Terminate();
TCCCUSER_API void TCCC_SendDTMF(const char digit, TCCC_OnSendDTMFHandler callback);
TCCCUSER_API void TCCC_Mute();
TCCCUSER_API void TCCC_Unmute();
TCCCUSER_API void TCCC_StartLocalAudio(int quality);
TCCCUSER_API const char* TCCC_GetSDKVersion();
TCCCUSER_API void TCCC_CallExperimentalAPI(const char* commandType, const char* jsonStr);
TCCCUSER_API void TCCC_StartPlayMusic(const char* path, int loopCount);
TCCCUSER_API void TCCC_StopPlayMusic();
TCCCUSER_API void TCCC_SetLogLevel(int level);
TCCCUSER_API void TCCC_SetConsoleEnabled(bool enabled);
TCCCUSER_API void TCCC_EnableAudioVolumeEvaluation(uint32_t interval, bool enable_vad);
TCCCUSER_API void TCCC_SetLogDirectory(const char* path);
// 设备
TCCCUSER_API void TCCC_GetDeviceManager();
TCCCUSER_API void TDEVICE_SetAudioCaptureVolume(int volume);
TCCCUSER_API int TDEVICE_GetAudioCaptureVolume();
TCCCUSER_API void TDEVICE_SetAudioPlayoutVolume(int volume);
TCCCUSER_API int TDEVICE_GetAudioPlayoutVolume();

TCCCUSER_API void TDEVICE_SetAudioRoute(int route);

// for test ,callback的message返回token
TCCCUSER_API void TCCC_GenTestUserSigByUser(const char* secretId, const char* secretKey, const char* userId,
                                            const char* clientData, uint32_t sdkAppId, TCCC_OnLogoutHandler callback);
// 仅仅移动端
#if __ANDROID__ || (__APPLE__ && TARGET_OS_IOS)
#endif
// 仅仅pc端
#if (__APPLE__ && TARGET_OS_MAC && !TARGET_OS_IPHONE) || _WIN32
#endif
