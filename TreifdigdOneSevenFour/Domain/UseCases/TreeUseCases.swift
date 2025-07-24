import Foundation

protocol TreeRepository {
    func getAllTrees() -> [Tree]
    func getTree(by id: UUID) -> Tree?
    func getFavoriteTrees() -> [Tree]
    func addTree(_ tree: Tree)
    func updateTree(_ tree: Tree)
    func deleteTree(by id: UUID)
    func searchTrees(query: String, category: TreeCategory?, environment: TreeEnvironment?) -> [Tree]
    func toggleFavorite(treeId: UUID) -> Bool
}

class GetAllTreesUseCase {
    private let repository: TreeRepository
    
    init(repository: TreeRepository) {
        self.repository = repository
    }
    
    func execute() -> [Tree] {
        return repository.getAllTrees()
    }
}

class GetTreeByIdUseCase {
    private let repository: TreeRepository
    
    init(repository: TreeRepository) {
        self.repository = repository
    }
    
    func execute(id: UUID) -> Tree? {
        return repository.getTree(by: id)
    }
}

class GetFavoriteTreesUseCase {
    private let repository: TreeRepository
    
    init(repository: TreeRepository) {
        self.repository = repository
    }
    
    func execute() -> [Tree] {
        return repository.getFavoriteTrees()
    }
}

class SearchTreesUseCase {
    private let repository: TreeRepository
    
    init(repository: TreeRepository) {
        self.repository = repository
    }
    
    func execute(query: String, category: TreeCategory? = nil, environment: TreeEnvironment? = nil) -> [Tree] {
        return repository.searchTrees(query: query, category: category, environment: environment)
    }
}

class ToggleFavoriteTreeUseCase {
    private let repository: TreeRepository
    
    init(repository: TreeRepository) {
        self.repository = repository
    }
    
    func execute(treeId: UUID) -> Bool {
        return repository.toggleFavorite(treeId: treeId)
    }
}

class AddTreeUseCase {
    private let repository: TreeRepository
    
    init(repository: TreeRepository) {
        self.repository = repository
    }
    
    func execute(tree: Tree) {
        repository.addTree(tree)
    }
}

class UpdateTreeUseCase {
    private let repository: TreeRepository
    
    init(repository: TreeRepository) {
        self.repository = repository
    }
    
    func execute(tree: Tree) {
        repository.updateTree(tree)
    }
}

class DeleteTreeUseCase {
    private let repository: TreeRepository
    
    init(repository: TreeRepository) {
        self.repository = repository
    }
    
    func execute(id: UUID) {
        repository.deleteTree(by: id)
    }
} 