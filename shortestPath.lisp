(setq *print-case* :capitalize)

(defparameter *graph*
	'(
		(a b 3)
		(b c 1)
		(b d 5)
		(c d 2)
		(d b 2)
	)
)

(defparameter *visited* '())
(defparameter *multipleNodes* '())
(defvar startNode '(a)); Change Start Node here
(defvar endNode '(d)); Change End Node here
(defvar found 0)
(defvar currentNode '())
(defvar validNode 1)
(defvar validStartNode 0)
(defvar validEndNode 0)
(defvar node1 '())
(defvar node2 '())
(defvar totalCost 0)

(if (eq (car startNode) (car endNode)) ; Checks if the startNode and the endNode are the same or not
	(progn
		(setq validNode 0)
		(format t "The start node and the end node are the same. ~%")
	)
)

(loop for x in *graph* do	; Checks if startNode is in the graph
	(if (eq (car x) (car startNode))
		(progn
			(setq validStartNode 1)
		)
	)
)

(loop for x in *graph* do	; Checks if endNode is in the graph
	(if (eq (cadr x) (car endNode))
		(progn
			(setq validEndNode 1)
		)
	)
)

(if (= validStartNode 0)
	(progn
		(setq validNode 0)
		(format t "Either Start node ~a does not exist or reaching End node ~a from start node ~a is not possible in this graph. ~%" startNode endNode startNode)
	)
)

(if (and (= validEndNode 0) (= validNode 1))
	(progn
		(setq validNode 0)
		(format t "Either End node ~a does not exist or reaching End node ~a from start node ~a is not possible in this graph. ~%" endNode endNode startNode)
	)
)

(if (= validNode 1)
(progn
	(loop for x in *graph* do	; Find the start node in the graph and sets it to current node
		(if (eq (car x) (car startNode))
			(progn
				(setq currentNode x)
				(if (eq (member (car currentNode) *visited*) nil)
					(progn
						(push (car currentNode) *visited*)
						(return x)
					)
				)
			)
		)
	)
	(loop	; Main outer loop, can only get out of the loop if the endNode is found
	(if (or (eq (car currentNode) (car endNode)) (eq (cadr currentNode) (car endNode))) ; Check if the currentNode or the node next to 
																						; currentNode is the endNode.
		(progn
			(setq totalCost (+ (caddr currentNode) totalCost))
			(return found)
		)
	)
	(loop for x in *graph* do	; Main logic loop 
		(if (and (eq (car x) (cadr currentNode)) (eq (member (cadr x) *visited*) nil)) ; Checks which node is connected to currentNode
																					   ; and whether it has been visited or not. x used
																					   ; in the else condition of *multipleNodes* >= 2
																					   ; if condition
			(progn
				(loop for y in *graph* do	; Checks if the current node is pointing to multiple nodes
					(if (eq (car y) (car currentNode))
						(progn
							(push y *multipleNodes*)
						)
					)
				)
				(if (>= (list-length *multipleNodes*) 2)	; If true, finds the shortest path between the two paths
					(progn
						(if (< (caddr(car *multipleNodes*)) (caddr(cadr *multipleNodes*)))
							(progn ; Takes the left path
								(setq node1 (cadr(car *multipleNodes*)))
								(setq totalCost (+ (caddr(car *multipleNodes*)) totalCost))
								(loop for g in *graph* do	; Finds the node in the graph that corrosponds to node1
									(if (eq (car g) node1)
										(progn
											(setq node1 g)
										)
									)
								)
								(setq currentNode node1)
							)
							(progn							; Takes the right path
								(setq node2 (cadr(cadr *multipleNodes*)))
								(setq totalCost (+ (caddr(cadr *multipleNodes*)) totalCost))
								(loop for h in *graph* do	; Finds the node in the graph that corrosponds to node2
									(if (eq (car h) node2)
										(progn
											(setq node2 h)
										)
									)
								)
								(setq currentNode node2)
							)
						)
					)
					(progn ; currentNode was not pointing to multiple nodes
						(setq totalCost (+ (caddr currentNode) totalCost))
						(setq currentNode x)
					)	
				)
				(push (car currentNode) *visited*)
				(setq *multipleNodes* '())
				(return x)
			)
		)
	)
)
(push (car endNode) *visited*)
(format t "The minimum path between ~a and ~a is: ~a with a total cost of ~a ~%" startNode endNode (reverse *visited*) totalCost)
)
)
