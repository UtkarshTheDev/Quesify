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
        // First pass: Groq (Llama 3.2 Vision) for speed
        vision: {
            provider: (process.env.AI_PROVIDER_VISION as AIProvider) || "groq",
            model: process.env.AI_MODEL_VISION || "llama-3.2-11b-vision-preview",
        } as ModelConfig,
        
        // MCQ solutions & high-speed validation
        // First pass: Groq (Llama 3 70B)
        fast: {
            provider: (process.env.AI_PROVIDER_FAST as AIProvider) || "groq",
            model: process.env.AI_MODEL_FAST || "llama3-70b-8192",
        } as ModelConfig,
        
        // Complex reasoning (LA, charts)
        // First pass: Groq (Llama 3 70B)
        reasoning: {
            provider: (process.env.AI_PROVIDER_REASONING as AIProvider) || "groq",
            model: process.env.AI_MODEL_REASONING || "llama3-70b-8192",
        } as ModelConfig,
        
        // Feedback refinement & updates (Tweak / Regeneration)
        updates: {
            provider: (process.env.AI_PROVIDER_UPDATES as AIProvider) || "gemini",
            model: process.env.AI_MODEL_UPDATES || "gemini-3.0-flash-preview",
        } as ModelConfig,
        
        // User Q&A / Chat
        qa: {
            provider: (process.env.AI_PROVIDER_QA as AIProvider) || "gemini",
            model: process.env.AI_MODEL_QA || "gemini-3.0-flash-preview",
        } as ModelConfig,

        // High Quality / Regeneration fallback (New category)
        best: {
            provider: "gemini",
            model: "gemini-3.0-flash-preview", 
        } as ModelConfig,

        // Embedding model (currently only gemini supported)
        embedding: {
            provider: "gemini",
            model: process.env.AI_MODEL_EMBEDDING || "text-embedding-004",
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
