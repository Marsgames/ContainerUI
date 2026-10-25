import SwiftUI

@Observable @MainActor
final class ImagesViewModel
{
    var images: [ContainerImage] = []
    var isLoading = false
    var error: String?

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
}

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
                }
                .buttonStyle(.plain)
            }
        }
        .if(vm.error != nil)
        { view in
            view.overlay(alignment: .bottom)
            {
                ErrorBanner(message: vm.error!) { vm.error = nil }
                    .padding()
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
        }
    }

    private var imageList: some View
    {
        ScrollView
        {
            LazyVStack(spacing: 1)
            {
                ForEach(vm.images) { image in ImageRow(image: image) }
            }
            .padding(.top, 1)
        }
    }
}

struct ImageRow: View
{
    let image: ContainerImage

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

        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .background(Color(hex: 0x2A2A2A))
    }
}
