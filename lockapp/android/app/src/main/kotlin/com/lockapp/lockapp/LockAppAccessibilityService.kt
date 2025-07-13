package com.lockapp.lockapp

import android.accessibilityservice.AccessibilityService
import android.view.accessibility.AccessibilityEvent

class LockAppAccessibilityService : AccessibilityService() {
    
    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        // Şu an için boş - gelecekte uygulama kilitleme için kullanılacak
    }

    override fun onInterrupt() {
        // Servis kesildiğinde
    }

    override fun onServiceConnected() {
        super.onServiceConnected()
        // Servis bağlandığında
    }
} 