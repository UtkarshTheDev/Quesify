// AI Configuration - Single source of truth for all AI settings
export const AI_CONFIG = {
    // Models
    models: {
        // Default/Fast model for high-speed tasks (extraction, validation)
        fast: process.env.AI_MODEL_FAST || "gemini-2.0-flash",
        // Reasoning model for complex logic (solutions)
        reasoning: process.env.AI_MODEL_REASONING || "gemini-2.5-flash",
        // Vision model for image analysis
        vision: process.env.AI_MODEL_VISION || "gemini-2.5-flash-lite",
        // Embedding model for vector search
        embedding: process.env.AI_MODEL_EMBEDDING || "text-embedding-004",
    },

    // Generation settings
    generation: {
        temperature: 0.7,
        maxOutputTokens: 4096,
    },

    // Retry settings
    retry: {
        maxAttempts: 3,
        delayMs: 1000,
    },

    // Debugging
    debug: process.env.NODE_ENV === "development",
} as const;

export type ModelType = keyof typeof AI_CONFIG.models;
