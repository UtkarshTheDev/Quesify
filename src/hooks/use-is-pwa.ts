'use client';

import { useEffect, useState } from 'react';

/**
 * Hook to detect if the user is accessing the app via an installed PWA, 
 * TWA (Android), or iOS Home Screen add.
 */
export function useIsPWA(): boolean {
    const [isPWA, setIsPWA] = useState(false);

    useEffect(() => {
        const checkIsPWA = () => {
            const isStandalone =
                window.matchMedia('(display-mode: standalone)').matches ||
                window.matchMedia('(display-mode: minimal-ui)').matches ||
                (window.navigator as any).standalone === true ||
                document.referrer.includes('android-app://');

            setIsPWA(isStandalone);
        };

        // Initial check
        checkIsPWA();

        // Listen for changes (e.g., if user installs and opens while app is running)
        const mql = window.matchMedia('(display-mode: standalone)');

        // Modern API
        if (mql.addEventListener) {
            mql.addEventListener('change', checkIsPWA);
            return () => mql.removeEventListener('change', checkIsPWA);
        }
        // Fallback for older browsers
        else {
            // @ts-ignore
            mql.addListener(checkIsPWA);
            // @ts-ignore
            return () => mql.removeListener(checkIsPWA);
        }
    }, []);

    return isPWA;
}
