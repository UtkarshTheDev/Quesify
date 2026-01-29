export const SectionFade = ({
    children,
    isLoaded,
}: {
    children: React.ReactNode;
    isLoaded: boolean;
}) => <div className="transition-all duration-700">{children}</div>;
