import Foundation


// MARK: - Internal Methods
//
extension SPAppDelegate {

    /// Returns the actual Selected Tag Name **Excluding** navigation tags, such as Trash or Untagged Notes.
    ///
    /// TODO: This should be gone... **the second** the AppDelegate is Swift-y. We should simply keep a `NoteListFilter` instance.
    ///
    @objc
    var filteredTagName: String? {
        guard let selectedTag = SPAppDelegate.shared().selectedTag,
            case let .tag(name) = NotesListFilter(selectedTag: selectedTag) else {
                return nil
        }

        return name
    }
}


// MARK: - URL Handlers
//
extension SPAppDelegate {

    /// Opens the Note associated with a given URL instance, when possible
    ///
    @objc
    func handleOpenNote(url: NSURL) -> Bool {
        guard let simperiumKey = url.interlinkSimperiumKey, let note = simperium.notesBucket.object(forKey: simperiumKey) as? Note else {
            return false
        }

        let editor = SPNoteEditorViewController()
        editor.update(note)
        navigationController.setViewControllers([noteListViewController, editor], animated: true)

        return true
    }
}


// MARK: - UIViewControllerRestoration
//
@objc
extension SPAppDelegate: UIViewControllerRestoration {
    static let tagsListIdentifier = SPTagsListViewController.classNameWithoutNamespaces
    static let noteListIdentifier = SPNoteListViewController.classNameWithoutNamespaces
    static let noteEditorIdentifier = SPNoteEditorViewController.classNameWithoutNamespaces
    static let sidebarIdentifier = SPSidebarContainerViewController.classNameWithoutNamespaces
    static let navControllerIdentifier = SPNavigationController.classNameWithoutNamespaces

    @objc
    func configureStateRestoration() {
        tagListViewController.restorationIdentifier = SPAppDelegate.tagsListIdentifier
        tagListViewController.restorationClass = SPAppDelegate.self

        noteListViewController.restorationIdentifier = SPAppDelegate.noteListIdentifier
        noteListViewController.restorationClass = SPAppDelegate.self

        noteEditorViewController.restorationIdentifier = SPAppDelegate.noteEditorIdentifier
        noteEditorViewController.restorationClass = SPAppDelegate.self

        navigationController.restorationIdentifier = SPAppDelegate.navControllerIdentifier
        navigationController.restorationClass = SPAppDelegate.self

        sidebarViewController.restorationIdentifier = SPAppDelegate.sidebarIdentifier
        sidebarViewController.restorationClass = SPAppDelegate.self
    }

    @objc
    public static func viewController(withRestorationIdentifierPath identifierComponents: [String], coder: NSCoder) -> UIViewController? {

        guard
            let appDelegate = UIApplication.shared.delegate as? SPAppDelegate,
            let component = identifierComponents.last
        else {
            return nil
        }

        if component == tagsListIdentifier {
            return appDelegate.tagListViewController
        }

        if component == noteListIdentifier {
            return appDelegate.noteListViewController
        }

        if component == noteEditorIdentifier {
            return appDelegate.noteEditorViewController
        }

        if component == navControllerIdentifier {
            return appDelegate.navigationController
        }

        if component == sidebarIdentifier {
            return appDelegate.sidebarViewController
        }

        return nil
    }
}
