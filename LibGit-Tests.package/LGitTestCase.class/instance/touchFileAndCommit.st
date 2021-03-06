helpers
touchFileAndCommit
	| blob treeBuilder subTree rootTree author |
	self touchFile.
	blob := LGitBlob of: repository fromFile: self file.
	treeBuilder := (LGitTreeBuilder of: self repository)
		createNew;
		addEntry: blob filename: self file basename;
		yourself.
	subTree := treeBuilder newTree.
	treeBuilder
		clear;
		addEntry: subTree filename: self file parent basename.
	rootTree := treeBuilder newTree.
	author := LGitSignature name: 'Bart Simpson' email: 'bartman@gotham.com'.
	(LGitCommitBuilder of: repository)
		tree: rootTree;
		message: 'eat my shorts';
		parents: { self repository head object };
		updateReference: repository master;
		author: author;
		committer: author;
		writeCommit.
		
	self repository index
		addAll;
		updateAll;
		writeToDisk