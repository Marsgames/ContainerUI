import SwiftUI

@Observable @MainActor
final class ImagesViewModel
{
    var images: [ContainerImage] = []
    var isLoading = false
    var error: String?
    var pendingActions: Set<String> = []
    var imageToDelete: ContainerImage?
    var showPullSheet = false

    private let repository: any IImageRepository

    init(repository: any IImageRepository)
    {
        self.repository = repository
    }

    func refresh() async
    {
        isLoading = true
        error = nil
        do
        {
            images = try await repository.listAll()
        }
        catch
        {
            self.error = Errors.CLIMapper.map(error).userMessage
        }
        isLoading = false
    }

    func confirmDelete(_ image: ContainerImage)
    {
        imageToDelete = image
    }

    func delete(_ image: ContainerImage) async
    {
        pendingActions.insert(image.id)
        defer { pendingActions.remove(image.id) }
        do
        {
            try await repository.delete(reference: image.reference)
            await refresh()
        }
        catch
        {
            self.error = Errors.CLIMapper.map(error).userMessage
        }
    }

    func pull(reference: String) async
    {
        isLoading = true
        error = nil
        do
        {
            try await repository.pull(reference: reference)
            await refresh()
        }
        catch
        {
            self.error = Errors.CLIMapper.map(error).userMessage
        }
        isLoading = false
    }
}

// MARK: - ImagesView

struct ImagesView: View
{
    @State private var vm: ImagesViewModel

    init(repository: any IImageRepository)
    {
        _vm = State(wrappedValue: ImagesViewModel(repository: repository))
    }

    var body: some View
    {
        ZStack
        {
            Color(hex: 0x242424).ignoresSafeArea()

            if vm.isLoading && vm.images.isEmpty
            {
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(Color(hex: 0x4ADE80))
            }
            else if vm.images.isEmpty
            {
                emptyState
            }
            else
            {
                imageList
            }
        }
        .task { await vm.refresh() }
        .toolbar
        {
            ToolbarItem(placement: .automatic)
            {
                Button { Task { await vm.refresh() } } label:
                {
                    Image(systemName: "arrow.clockwise")
                        .foregroundColor(.white.opacity(0.7))
                        .padding(.horizontal, 4)
                }
                .buttonStyle(.plain)
            }
            ToolbarItem(placement: .automatic)
            {
                Button { vm.showPullSheet = true } label:
                {
                    Image(systemName: "arrow.down.circle")
                        .foregroundColor(.white.opacity(0.7))
                        .padding(.horizontal, 4)
                }
                .buttonStyle(.plain)
            }
        }
        .sheet(isPresented: $vm.showPullSheet)
        {
            PullImageSheet
            { reference in
                vm.showPullSheet = false
                Task { await vm.pull(reference: reference) }
            } onCancel: {
                vm.showPullSheet = false
            }
        }
        .confirmationDialog(
            "Delete \"\(vm.imageToDelete?.repository ?? "")\"?",
            isPresented: Binding(get: { vm.imageToDelete != nil }, set: { if !$0 { vm.imageToDelete = nil } }),
            titleVisibility: .visible
        )
        {
            Button("Delete", role: .destructive)
            {
                if let image = vm.imageToDelete { Task { await vm.delete(image) } }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will permanently remove the image from local storage.")
        }
        .if(vm.error != nil)
        { view in
            view.overlay(alignment: .bottom)
            {
                ErrorBanner(message: vm.error!) { vm.error = nil }
                    .padding()
            }
        }
        .overlay
        {
            if vm.isLoading && !vm.images.isEmpty
            {
                VStack
                {
                    Spacer()
                    HStack(spacing: 10)
                    {
                        ProgressView().progressViewStyle(.circular).scaleEffect(0.7).tint(.white)
                        Text("Pulling image…")
                            .foregroundColor(.white.opacity(0.7))
                            .font(.system(size: 12))
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color(hex: 0x2A2A2A).cornerRadius(10))
                    .padding(.bottom, 20)
                }
            }
        }
    }

    private var emptyState: some View
    {
        VStack(spacing: 12)
        {
            Image(systemName: "photo.on.rectangle")
                .font(.system(size: 40, weight: .thin))
                .foregroundColor(.white.opacity(0.3))
            Text("No images")
                .foregroundColor(.white.opacity(0.4))
                .font(.system(size: 15))
            Button { vm.showPullSheet = true } label:
            {
                Text("Pull an image")
                    .font(.system(size: 13))
                    .foregroundColor(Color(hex: 0x4ADE80))
            }
            .buttonStyle(.plain)
        }
    }

    private var imageList: some View
    {
        ScrollView
        {
            LazyVStack(spacing: 1)
            {
                ForEach(vm.images)
                { image in
                    ImageRow(
                        image: image,
                        isPending: vm.pendingActions.contains(image.id)
                    )
                    { vm.confirmDelete(image) }
                }
            }
            .padding(.top, 1)
        }
    }
}

// MARK: - ImageRow

struct ImageRow: View
{
    let image: ContainerImage
    let isPending: Bool
    let onDelete: () -> Void

    var body: some View
    {
        HStack(spacing: 14)
        {
            Image(systemName: "photo.on.rectangle")
                .font(.system(size: 14, weight: .light))
                .foregroundColor(.white.opacity(0.5))
                .frame(width: 22)

            VStack(alignment: .leading, spacing: 2)
            {
                Text(image.repository)
                    .foregroundColor(.white)
                    .font(.system(size: 13, weight: .medium))
                Text(image.tag)
                    .foregroundColor(.white.opacity(0.45))
                    .font(.system(size: 11))
            }

            Spacer()

            if isPending
            {
                ProgressView()
                    .progressViewStyle(.circular)
                    .scaleEffect(0.6)
                    .tint(.white.opacity(0.5))
                    .frame(width: 28, height: 28)
            }
            else
            {
                Button(action: onDelete)
                {
                    Image(systemName: "trash")
                        .font(.system(size: 11))
                        .foregroundColor(.white.opacity(0.35))
                        .frame(width: 28, height: 28)
                        .background(Color.white.opacity(0.05))
                        .cornerRadius(6)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .background(Color(hex: 0x2A2A2A))
        .opacity(isPending ? 0.6 : 1)
    }
}

// MARK: - PullImageSheet

struct PullImageSheet: View
{
    let onPull: (String) -> Void
    let onCancel: () -> Void

    @State private var reference = ""

    var body: some View
    {
        ZStack
        {
            Color(hex: 0x1D1D1D).ignoresSafeArea()

            VStack(alignment: .leading, spacing: 20)
            {
                Text("Pull image")
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .semibold))

                VStack(alignment: .leading, spacing: 6)
                {
                    Text("Image reference")
                        .foregroundColor(.white.opacity(0.5))
                        .font(.system(size: 11))

                    TextField("e.g. docker.io/library/ubuntu:latest", text: $reference)
                        .textFieldStyle(.plain)
                        .foregroundColor(.white)
                        .font(.system(size: 13, design: .monospaced))
                        .padding(10)
                        .background(Color(hex: 0x2A2A2A))
                        .cornerRadius(8)
                        .onSubmit { if !reference.trimmingCharacters(in: .whitespaces).isEmpty { onPull(reference) } }
                }

                HStack
                {
                    Spacer()
                    Button("Cancel", action: onCancel)
                        .buttonStyle(.plain)
                        .foregroundColor(.white.opacity(0.5))
                        .font(.system(size: 13))

                    Button("Pull")
                    {
                        onPull(reference.trimmingCharacters(in: .whitespaces))
                    }
                    .buttonStyle(.plain)
                    .foregroundColor(reference.trimmingCharacters(in: .whitespaces).isEmpty ? .white.opacity(0.3) : Color(hex: 0x4ADE80))
                    .font(.system(size: 13, weight: .semibold))
                    .disabled(reference.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .padding(24)
        }
        .frame(width: 420, height: 180)
    }
}
