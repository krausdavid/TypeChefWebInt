USETEXTLINKS = 1
STARTALLOPEN = 0
USEICONS = 1
BUILDALL = 0
USEFRAMES = 0
PRESERVESTATE = 1
HIGHLIGHT = 0
P1 = "http://www.mathematik.uni-marburg.de/~eifx/TypeChefWebInt/php/project?choice=view&files="
P2 = "&project=busybox1185_1"
C1 = "<td valign=middle><input type=checkbox id=\"chkbox"
C2 = "\"></td>"
ICONPATH = 'http://www.mathematik.uni-marburg.de/~eifx/TypeChefWebInt/php/include/images/treeview/'
MAX_LENGTH = 700
foldersTree = gFld("<i>BusyBox 1.18.5 delta:1</i>", "")
foldersTree.treeID = "Frameset"
foldersTree.iconSrc = ICONPATH + "folderopenfail.gif"
foldersTree.iconSrcClosed = ICONPATH + "folderclosedfail.gif"
dirlibbb = insFld(foldersTree, gFld("libbb", ""))
dirlibbb.iconSrc = ICONPATH + "folderopenfail.gif"
dirlibbb.iconSrcClosed = ICONPATH + "folderclosedfail.gif"
doc277 = insDoc(dirlibbb, gLnk("S", "appletlib.c", P1+"libbb/appletlib"+P2))
doc277.iconSrc = ICONPATH + "filecompilefail.gif"
doc277.prependHTML = C1+"277"+C2
dirprocps = insFld(foldersTree, gFld("procps", ""))
dirprocps.iconSrc = ICONPATH + "folderopenfail.gif"
dirprocps.iconSrcClosed = ICONPATH + "folderclosedfail.gif"
doc557 = insDoc(dirprocps, gLnk("S", "ps.c", P1+"procps/ps"+P2))
doc557.iconSrc = ICONPATH + "filecompilefail.gif"
doc557.prependHTML = C1+"557"+C2
