import { Geist, Geist_Mono, Outfit } from "next/font/google";
import localFont from "next/font/local";
import type { Metadata, Viewport } from "next";
import "./globals.css";
import { Providers } from "@/components/providers";

const geistSans = Geist({
    variable: "--font-geist-sans",
    subsets: ["latin"],
});

const geistMono = Geist_Mono({
    variable: "--font-geist-mono",
    subsets: ["latin"],
});

const outfit = Outfit({
    variable: "--font-outfit",
    subsets: ["latin"],
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
    manifest: "/manifest.json",
    icons: {
        //   icon: '/logo.png',
        //   shortcut: '/logo.png',
        //   apple: '/logo.png',
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
            </body>
        </html>
    );
}
