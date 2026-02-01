import { MetadataRoute } from "next";

export default function manifest(): MetadataRoute.Manifest {
    return {
        name: "Quesify - AI Question Bank",
        short_name: "Quesify",
        description: "Organize and practice your questions with AI",
        start_url: "/dashboard",
        scope: "/",
        display: "standalone",
        background_color: "#0a0a0a",
        theme_color: "#0a0a0a",
        id: "/",
        categories: ["education", "productivity", "study"],
        orientation: "portrait",
        related_applications: [
            {
                platform: "play",
                id: "app.vercel.quesify.twa",
                url: "https://play.google.com/store/apps/details?id=app.vercel.quesify.twa"
            }
        ],
        prefer_related_applications: true,
        icons: [
            {
                src: "/android-chrome-192x192.png",
                sizes: "192x192",
                type: "image/png",
                purpose: "maskable",
            },
            {
                src: "/android-chrome-512x512.png",
                sizes: "512x512",
                type: "image/png",
                purpose: "maskable",
            },
            {
                src: "/logo.png",
                sizes: "512x512",
                type: "image/png",
                purpose: "any",
            },
        ],
    };
}
