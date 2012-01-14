struct list_head {
 struct list_head *next, *prev;
};
void __list_add(struct list_head * add, struct list_head * prev, struct list_head * next);
void list_add(struct list_head *add, struct list_head *head);
void list_add_tail(struct list_head *add, struct list_head *head);
void __list_del(struct list_head * prev, struct list_head * next);
void list_del(struct list_head *entry);
void list_del_init(struct list_head *entry);
int list_empty(struct list_head *head);
void list_splice(struct list_head *list, struct list_head *head);
void __list_add(struct list_head * add,
 struct list_head * prev,
 struct list_head * next)
{
 next->prev = add;
 add->next = next;
 add->prev = prev;
 prev->next = add;
}
void list_add(struct list_head *add, struct list_head *head)
{
 __list_add(add, head, head->next);
}
void list_add_tail(struct list_head *add, struct list_head *head)
{
 __list_add(add, head->prev, head);
}
void __list_del(struct list_head * prev, struct list_head * next)
{
 next->prev = prev;
 prev->next = next;
}
void list_del(struct list_head *entry)
{
 __list_del(entry->prev, entry->next);
}
void list_del_init(struct list_head *entry)
{
 __list_del(entry->prev, entry->next);
 do { (entry)->next = (entry); (entry)->prev = (entry); } while (0);
}
int list_empty(struct list_head *head)
{
 return head->next == head;
}
void list_splice(struct list_head *list, struct list_head *head)
{
 struct list_head *first = list->next;
 if (first != list) {
  struct list_head *last = list->prev;
  struct list_head *at = head->next;
  first->prev = head;
  head->next = first;
  last->next = at;
  at->prev = last;
 }
}
