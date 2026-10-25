import SwiftUI

struct OnboardingView: View
{
    let onFinish: () -> Void

    @State private var currentStep = 0

    private let steps: [OnboardingStep] = [
        OnboardingStep(
            icon: "shippingbox",
            title: String(localized: "onboarding.welcome.title"),
            body: String(localized: "onboarding.welcome.body"),
            accentColor: Color(hex: 0x4ADE80)
        ),
        OnboardingStep(
            icon: "terminal",
            title: String(localized: "onboarding.cli.title"),
            body: String(localized: "onboarding.cli.body"),
            accentColor: Color(hex: 0xFF6B35)
        ),
        OnboardingStep(
            icon: "checkmark.circle",
            title: String(localized: "onboarding.ready.title"),
            body: String(localized: "onboarding.ready.body"),
            accentColor: Color(hex: 0x4ADE80)
        )
    ]

    var body: some View
    {
        ZStack
        {
            Color(hex: 0x1D1D1D).ignoresSafeArea()

            VStack(spacing: 0)
            {
                Spacer()

                // Step content
                ZStack
                {
                    ForEach(steps.indices, id: \.self)
                    { index in
                        if index == currentStep
                        {
                            stepView(steps[index])
                                .transition(.opacity)
                        }
                    }
                }
                .animation(.easeInOut(duration: 0.3), value: currentStep)
                .frame(height: 340)

                Spacer()

                // Dots + button
                VStack(spacing: 24)
                {
                    dots

                    Button(action: advance)
                    {
                        Text(currentStep == steps.count - 1
                             ? String(localized: "onboarding.button.start")
                             : String(localized: "onboarding.button.next"))
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color(hex: 0x1D1D1D))
                            .frame(width: 220, height: 44)
                            .background(Color(hex: 0x4ADE80))
                            .cornerRadius(10)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.bottom, 48)
            }
        }
        .frame(width: 520, height: 480)
    }

    private func stepView(_ step: OnboardingStep) -> some View
    {
        VStack(spacing: 24)
        {
            Image(systemName: step.icon)
                .font(.system(size: 52, weight: .thin))
                .foregroundColor(step.accentColor)

            VStack(spacing: 12)
            {
                Text(step.title)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)

                Text(step.body)
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.6))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .frame(maxWidth: 360)
            }
        }
        .padding(.horizontal, 40)
    }

    private var dots: some View
    {
        HStack(spacing: 8)
        {
            ForEach(steps.indices, id: \.self)
            { index in
                Circle()
                    .fill(index == currentStep ? Color(hex: 0x4ADE80) : Color.white.opacity(0.2))
                    .frame(width: 6, height: 6)
                    .animation(.easeInOut(duration: 0.2), value: currentStep)
            }
        }
    }

    private func advance()
    {
        if currentStep < steps.count - 1
        {
            withAnimation { currentStep += 1 }
        }
        else
        {
            UserDefaults.standard.set(true, forKey: "onboardingCompleted")
            onFinish()
        }
    }
}

private struct OnboardingStep
{
    let icon: String
    let title: String
    let body: String
    let accentColor: Color
}
