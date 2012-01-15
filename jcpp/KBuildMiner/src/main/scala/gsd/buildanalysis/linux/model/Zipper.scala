package gsd.buildanalysis.linux.model

/**
 * The following ZIPPER data structure is based on:
 * http://szeiger.de/blog/2009/12/27/a-zipper-for-scala-xml/
 * However, fixed some smaller bugs and rewrote parts in order to
 * suit my needs and to work with my own case classes.
 */
sealed case class NodeLoc(node: BNode, path: NodePath){

  protected def create(node: BNode, path: Hole) = NodeLoc(node, path)

  def leftOpt = path match {
    case Hole(tl :: l, p, r) =>
      Some(create(tl, Hole(l, p, node :: r)))
    case _ => None
  }

  def rightOpt = path match {
    case Hole(l, p, tr :: r) =>
      Some(create(tr, Hole(node :: l, p, r)))
    case _ => None
  }

  def downLastOp = {
    val ch = node.subnodes
    if( ch.isEmpty )
      None
    else
      Some( create( ch.last, Hole( ch.reverse.tail, this, Nil ) ) )
  }

  def set(n: BNode) = NodeLoc(n, path)

  def upOpt = path match {
    case h : Hole => {
      val ch = h.left.reverse ++ (node :: h.right)
      Some( NodeLoc( copyBNode( h.parent.node, ch ), h.parent.path) )
    }
    case _ => None
  }

  private def copyBNode( o: BNode, ch: List[BNode] ): BNode =
    BNode( o.ntype, ch, o.exp, o.details )

  def setChildren(ch: List[BNode]) =
    NodeLoc( copyBNode( node, ch ), path)

  /**
  * Top node?
  */
  final def isTop = path == Top

  /**
  * Get the root node of this tree.
  */
  final def top: NodeLoc = if(isTop) this else upOpt.get.top

  /**
  * Insert a node to the left of this location and return its new location
  * (error if we're already at the root)
  */
  final def +: (n: BNode) = path match {
    case Hole(l, p, r) => NodeLoc(n, Hole(l, p, node :: r))
    case _ => error("Cannot prepend to "+this)
  }

  /**
  * Insert a node to the right of this location and return its new location
  * (error if we're already at the root)
  */
  final def :+ (n: BNode) = path match {
    case Hole(l, p, r) => NodeLoc(n, Hole(node :: l, p, r))
    case _ => error( "Cannot append to " + this )
  }

  /**
  * Insert a node to the left of this node's children and return the
  * modified version of this location (of this node, not of the new child).
  */
  final def \+: (n: BNode) = setChildren( n :: node.subnodes )

  /**
  * Insert the given node to the right of this node's children and return the
  * modified version of this location (of this node, not of the new child).
  */
  final def :\+ (n: BNode) = setChildren( node.subnodes ::: ( n :: Nil ) )

}

sealed trait NodePath
final case object Top extends NodePath
final case class Hole(left: List[BNode],
                      parent: NodeLoc,
                      right: List[BNode]) extends NodePath

final class CachedParentNodeLoc(node: BNode, path: Hole) extends NodeLoc(node, path) {
  override def upOpt = Some(path.parent)
  override protected def create(node: BNode, path: Hole) =
    new CachedParentNodeLoc(node, path)
}

final class CachedTopNodeLoc(node: BNode) extends NodeLoc(node, Top) {
  override def upOpt = None
  override protected def create(node: BNode, path: Hole) =
    new CachedParentNodeLoc(node, path)
}

object NodeLoc {
  def apply(node: BNode): NodeLoc = new CachedTopNodeLoc(node)
}
