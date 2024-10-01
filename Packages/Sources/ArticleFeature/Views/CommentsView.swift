//
//  CommentsView.swift
//  ForPDA
//
//  Created by Ilia Lubianoi on 28.07.2024.
//

import SwiftUI
import ComposableArchitecture
import Models
import NukeUI
import SharedUI
import SkeletonUI
import SFSafeSymbols

// MARK: - Comments View

struct CommentsView: View {
    
    let store: StoreOf<ArticleFeature>
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Comments (\(store.comments.count.description)):", bundle: .module)
                .font(.title3)
                .bold()
                .padding(.vertical, 24)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            LazyVStack(spacing: 0) {
                ForEach(Array(store.scope(state: \.comments, action: \.comments))) { store in
                    WithPerceptionTracking {
                        CommentView(store: store)
                    }
                }
            }
        }
        .padding(.horizontal, 16)
    }
}

// MARK: - Comment View

struct CommentView: View {
    
    // MARK: - Properties
    
    @Environment(\.tintColor) private var tintColor
    
    @Perception.Bindable public var store: StoreOf<CommentFeature>
    
    public init(store: StoreOf<CommentFeature>) {
        self.store = store
    }
    
    // MARK: - Body
    
    var body: some View {
        WithPerceptionTracking {
            VStack(spacing: 0) {
                ZStack {
                    if store.comment.isDeleted {
                        Text("Comment has been deleted", bundle: .module)
                            .font(.subheadline)
                            .foregroundStyle(Color.Labels.quaternary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.bottom, 16)
                    } else {
                        VStack(spacing: 6) {
                            Header()
                            
                            if !store.comment.isHidden {
                                Text(store.comment.text)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .textSelection(.enabled)
                                
                                Footer()
                            }
                            
                            if store.comment.isHidden {
                                Button {
                                    store.send(.hiddenLabelTapped)
                                } label: {
                                    Text("Comment is hidden", bundle: .module)
                                        .font(.subheadline)
                                        .foregroundStyle(Color.Labels.quaternary)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.bottom, 16)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        // TODO: Jumps when used in LazyVStack
//                        .animation(.default, value: store.comment.isHidden)
                        .padding(.bottom, 16)
                        .overlay(alignment: .topLeading) {
                            Rectangle()
                                .foregroundStyle(Color.Background.primary)
                                .frame(width: 128, height: 16)
                                .offset(x: -1, y: -16)
                        }
                    }
                }
                .overlay(alignment: .leading) {
                    if store.comment.nestLevel > 0 {
                        HStack(spacing: 0) {
                            ForEach(1...store.comment.nestLevel, id: \.self) { index in
                                Rectangle()
                                    .frame(width: 1)
                                    .foregroundStyle(Color.Separator.secondary)
                                    .offset(x: CGFloat(-17 * index))
                            }
                        }
                    }
                }
                .padding(.leading, 16 * CGFloat(store.comment.nestLevel))
            }
            .alert($store.scope(state: \.alert, action: \.alert))
        }
    }
    
    // MARK: - Header
    
    @ViewBuilder
    private func Header() -> some View {
        HStack(spacing: 6) {
            Group {
                LazyImage(url: store.comment.avatarUrl) { state in
                    Group {
                        if let image = state.image {
                            image.resizable().scaledToFill()
                        } else {
                            Image.avatarDefault.resizable()
                        }
                    }
                    .skeleton(with: state.isLoading, shape: .rectangle)
                }
                .frame(width: 26, height: 26)
                .clipShape(Circle())
                .padding(.trailing, 2)
                
                Text(store.comment.authorName)
                    .font(.footnote)
                    .bold()
                    .foregroundStyle(Color.Labels.teritary)
                    .bold()
            }
            .onTapGesture {
                store.send(.profileTapped(userId: store.comment.authorId))
            }
            
            Group {
                Text(String("·"))
                Text(format(date: store.comment.date), bundle: .module)
            }
            .font(.footnote)
            .foregroundStyle(Color.Labels.teritary)
            
            Spacer()
        }
    }
    
    // MARK: - Footer
    
    @ViewBuilder
    private func Footer() -> some View {
        HStack(spacing: 2) {
            if store.comment.isEdited {
                Text("Edited", bundle: .module)
                    .font(.caption)
                    .foregroundStyle(Color.Labels.teritary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Spacer()
            
            ActionButton(symbol: .ellipsis) {
                store.send(.contextMenuTapped)
            }
            
            if !store.isArticleExpired {
                ActionButton(symbol: .arrowTurnUpLeft) {
                    store.send(.replyButtonTapped)
                }
                
                LikeButton()
                
                Text(String(store.comment.likesAmount))
                    .font(.subheadline)
                    .foregroundStyle(Color.Labels.teritary)
                    .padding(.trailing, 6)
            }
        }
    }
    
    // MARK: - Action Button
    
    @ViewBuilder
    private func ActionButton(
        symbol: SFSymbol,
        action: @escaping () -> Void
    ) -> some View {
        Button {
            action()
        } label: {
            Image(systemSymbol: symbol)
                .font(.body)
                .foregroundStyle(Color.Labels.teritary)
        }
        .frame(width: 32, height: 32)
    }
    
    // MARK: - Like Button
    
    @ViewBuilder
    private func LikeButton() -> some View {
        Button {
            store.send(.likeButtonTapped)
        } label: {
            Image(systemSymbol: store.isLiked ? .handThumbsupFill : .handThumbsup)
                .font(.body)
                .foregroundStyle(store.isLiked ? tintColor : Color.Labels.teritary)
                .bounceDownWholeSymbolEffect(value: store.isLiked)
        }
        .frame(width: 32, height: 32)
    }
}

// MARK: - Helpers

extension CommentView {
    func format(date: Date) -> LocalizedStringKey {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        
        let components = calendar.dateComponents([.second, .minute, .hour, .day], from: date, to: Date.now)
        
        if let seconds = components.second, seconds < 60, components.minute == 0, components.hour == 0, components.day == 0 {
            return "just now"
        } else if let minutes = components.minute, minutes < 60, components.hour == 0, components.day == 0 {
            return "\(minutes)m"
        } else if let hours = components.hour, hours < 24, components.day == 0 {
            return "\(hours)h"
        } else {
            formatter.dateFormat = "dd.MM.yy"
            return LocalizedStringKey(formatter.string(from: date))
        }
    }
}

// MARK: - Previews

#Preview {
    VStack {
        CommentsView(
            store: Store(
                initialState: ArticleFeature.State(articlePreview: .mock),
                reducer: {
                    ArticleFeature()
                })
        )

        Rectangle()
            .foregroundColor(Color(.systemGray6))
    }
}
