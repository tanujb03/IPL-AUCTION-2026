'use client';

import dynamic from 'next/dynamic';

const Logo3D = dynamic(() => import('@/components/Logo3D'), {
    ssr: false,
    loading: () => (
        <div className="logo3d-container">
            <div className="logo3d-loader">
                <div className="logo3d-spinner" />
            </div>
        </div>
    ),
});

export default function Loader({ text = "L O A D I N G" }: { text?: string }) {
    return (
        <div className="min-h-screen flex items-center justify-center overflow-hidden relative" style={{ background: 'radial-gradient(ellipse at center, #0a1628, #040b14)' }}>
            <div className="absolute inset-0 pointer-events-none overflow-hidden">
                {Array.from({ length: 20 }, (_, i) => {
                    // Deterministic pseudo-random to avoid hydration mismatch
                    const seed = (n: number) => {
                        const x = Math.sin(n * 9301 + 49297) * 233280;
                        return x - Math.floor(x);
                    };
                    return (
                        <div key={i} className="absolute rounded-full"
                            style={{
                                width: `${seed(i * 7 + 1) * 4 + 1}px`, height: `${seed(i * 7 + 2) * 4 + 1}px`,
                                left: `${seed(i * 7 + 3) * 100}%`, top: `${seed(i * 7 + 4) * 100}%`,
                                background: ['#2bb5cc', '#d4af37', '#2dd4a0'][i % 3],
                                opacity: seed(i * 7 + 5) * 0.4 + 0.1,
                                animation: `floatUp ${seed(i * 7 + 6) * 6 + 4}s ease-in-out infinite`,
                                animationDelay: `${seed(i * 7 + 7) * 3}s`,
                            }}
                        />
                    );
                })}
            </div>
            <div className="relative flex flex-col items-center z-10">
                <div style={{ width: '280px', height: '280px' }}>
                    <Logo3D className="w-full h-full" />
                </div>
                <div className="coin-loading-text" style={{ marginTop: '-1rem' }}>
                    {text.split('').map((char, index) => (
                        <span key={index}>{char}</span>
                    ))}
                </div>
            </div>
        </div>
    );
}
