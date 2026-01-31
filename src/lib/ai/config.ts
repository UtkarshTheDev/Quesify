// AI Configuration - Single source of truth for all AI settings
export type AIProvider = "gemini" | "groq";

export interface ModelConfig {
    provider: AIProvider;
    model: string;
}

export const AI_CONFIG = {
    // Models configuration by task category
    models: {
        // LaTeX extraction & image analysis (Vision tasks)
        vision: {
            provider: (process.env.AI_PROVIDER_VISION as AIProvider) || "gemini",
            model: process.env.AI_MODEL_VISION || "gemini-1.5-flash",
        } as ModelConfig,
        
        // MCQ solutions & high-speed validation
        fast: {
            provider: (process.env.AI_PROVIDER_FAST as AIProvider) || "gemini",
            model: process.env.AI_MODEL_FAST || "gemini-1.5-flash",
        } as ModelConfig,
        
        // Complex reasoning (LA, charts)
        reasoning: {
            provider: (process.env.AI_PROVIDER_REASONING as AIProvider) || "gemini",
            model: process.env.AI_MODEL_REASONING || "gemini-1.5-flash",
        } as ModelConfig,
        
        // Feedback refinement & updates
        updates: {
            provider: (process.env.AI_PROVIDER_UPDATES as AIProvider) || "gemini",
            model: process.env.AI_MODEL_UPDATES || "gemini-1.5-flash",
        } as ModelConfig,
        
        // User Q&A / Chat
        qa: {
            provider: (process.env.AI_PROVIDER_QA as AIProvider) || "gemini",
            model: process.env.AI_MODEL_QA || "gemini-1.5-flash",
        } as ModelConfig,

        // Embedding model (currently only gemini supported)
        embedding: {
            provider: "gemini",
            model: process.env.AI_MODEL_EMBEDDING || "gemini-embedding-001",
        } as ModelConfig,
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
