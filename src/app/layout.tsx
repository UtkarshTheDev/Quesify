import localFont from "next/font/local";
import type { Metadata, Viewport } from "next";
import "./globals.css";
import { Providers } from "@/components/providers";
import { Analytics } from '@vercel/analytics/next';

const geistSans = localFont({
    src: "../../public/fonts/geist/Geist-Variable.woff2",
    variable: "--font-geist-sans",
    weight: "100 900",
});

const geistMono = localFont({
    src: "../../public/fonts/geist-mono/GeistMono-Variable.woff2",
    variable: "--font-geist-mono",
    weight: "100 900",
});

const outfit = localFont({
    src: "../../public/fonts/outfit/Outfit-Variable.woff2",
    variable: "--font-outfit",
    weight: "100 900",
});

const charter = localFont({
    src: [
        {
            path: "../../public/fonts/charter/charter_regular.woff2",
            weight: "400",
            style: "normal",
        },
        {
            path: "../../public/fonts/charter/charter_italic.woff2",
            weight: "400",
            style: "italic",
        },
        {
            path: "../../public/fonts/charter/charter_bold.woff2",
            weight: "700",
            style: "normal",
        },
        {
            path: "../../public/fonts/charter/charter_bold_italic.woff2",
            weight: "700",
            style: "italic",
        },
    ],
    variable: "--font-charter",
});

export const metadata: Metadata = {
    title: "Quesify - AI-Powered Question Bank",
    description:
        "Upload question screenshots, AI auto-organizes them, and get personalized daily practice feeds.",
    manifest: "/manifest.webmanifest",
    appleWebApp: {
        capable: true,
        statusBarStyle: "default",
        title: "Quesify",
    },
    formatDetection: {
        telephone: false,
    },
    icons: {
        apple: "/apple-touch-icon.png",
    },
};

export const viewport: Viewport = {
    themeColor: "#0a0a0a",
    width: "device-width",
    initialScale: 1,
    maximumScale: 1,
};

export default function RootLayout({
    children,
}: Readonly<{
    children: React.ReactNode;
}>) {
    return (
        <html lang="en" className="dark">
            <body
                className={`${geistSans.variable} ${geistMono.variable} ${outfit.variable} ${charter.variable} antialiased`}
            >
                <Providers>{children}</Providers>
                <Analytics />
            </body>
        </html>
    );
}
