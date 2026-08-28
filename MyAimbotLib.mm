#import <Foundation/Foundation.h>
#import <objc/runtime.h>

// Standard Substrate definition so we don't need external headers
#ifdef __cplusplus
extern "C" {
#endif
void MSHookFunction(void *symbol, void *hook, void **old);
#ifdef __cplusplus
}
#endif

Class targetClass; 
SEL targetMethod;

void (*old_UpdateCamera)(id self, SEL _cmd, float deltaTime);

void new_UpdateCamera(id self, SEL _cmd, float deltaTime) {
    bool aimbotEnabled = true; 

    if (aimbotEnabled) {
        float* viewYaw = (float*)((uintptr_t)self + 0x1234); 
        float* viewPitch = (float*)((uintptr_t)self + 0x18); 

        float targetYaw = 45.0f;   
        float targetPitch = 10.0f; 

        float smoothing = 0.15f; 
        *viewYaw += (targetYaw - *viewYaw) * smoothing;
        *viewPitch += (targetPitch - *viewPitch) * smoothing;
    }

    old_UpdateCamera(self, _cmd, deltaTime);
}

__attribute__((constructor)) static void initialize_hooks() {
    @autoreleasepool {
        targetClass = objc_getClass("UnityPlayerCameraManager"); 
        targetMethod = sel_registerName("updateRotation:"); 

        if (targetClass && targetMethod) {
            Method originalMethod = class_getInstanceMethod(targetClass, targetMethod);
            if (originalMethod) {
                MSHookFunction((void *)method_getImplementation(originalMethod), 
                               (void *)&new_UpdateCamera, 
                               (void **)&old_UpdateCamera);
            }
        }
    }
}
