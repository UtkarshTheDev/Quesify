import { MetadataRoute } from "next";

export default function manifest(): MetadataRoute.Manifest {
    return {
        name: "Quesify - AI Question Bank",
        short_name: "Quesify",
        description: "Organize and practice your questions with AI",
        start_url: "/dashboard",
        display: "standalone",
        background_color: "#0a0a0a",
        theme_color: "#0a0a0a",
        id: "/",
        categories: ["education", "productivity", "study"],
        orientation: "portrait",
        icons: [
            {
                src: "/android-chrome-192x192.png",
                sizes: "192x192",
                type: "image/png",
            },
            {
                src: "/android-chrome-512x512.png",
                sizes: "512x512",
                type: "image/png",
            },
            {
                src: "/apple-touch-icon.png",
                sizes: "180x180",
                type: "image/png",
            },
        ],
    };
}
