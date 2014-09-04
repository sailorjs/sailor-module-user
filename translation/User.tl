LANGUAGES
	1:en
	2:es

User

	PRIMITIVES
	==========
	Name
		1:User
		2:Usuario
	NotFound
		1:User doesn't found.
		2:Usuario no encontrado.

	ATTRIBUTES
	==========
	Username
		Already
			1:Username already exist.
			2:Nombre de usuario ya registrado.
		NotFound
			1:Username doesn't found.
			2:Nombre de usuario no encontrado.

	Identifier
		NotFound
			1:Identifier doesn't found
			2:Identificador no encontrado

	Password
		DontMatch
			1:Passwords don't match
			2:La contraseña no coincide
		NotFound
			1:Password doesn't found
			2:Contraseña no encontrada
		MinLength
			1:Password doesn't be shorter than 5 characters
			2:La contraseña no puede ser más corta de 5 caracteres
		Invalid
			1:Password invalid. Only numbers and letters
			2:Contraseña incorrecta. Solamente números y letras

	Strategy
		Already
			1:Strategy already exist
			2:La estrategia ya existe
		NotSet
			1:Strategy don't set already
			2:La estrategia no ha sido establecida

	Email
		Already
			1:Email already exist
			2:Email already exist
		Wrong
			1:Wrong Email
			2:Wrong Email
		NotFound
			1:Email doesn't found
			2:Email no encontrado

	METHODS
	=========

	Signup
		Sucessful
			1:Signup successful
			2:Signup successful
		Failed
			1:Bad Signup
			2:Bad Signup

	Delete
		Sucessful
			1:Login successful
			2:Login successful
		Failed
			1:Bad login
			2:Bad login

	Login
		Sucessful
			1:Login successful
			2:Login successful
		Failed
			1:Bad login
			2:Bad login

	Token
		Sucessful
			1:Login successful
			2:Login successful
		Failed
			1:Bad login
			2:Bad login

	Info
		Sucessful
			1:Login successful
			2:Login successful
		Failed
			1:Bad login
			2:Bad login

	Update
		Sucessful
			1:Login successful
			2:Login successful
		Failed
			1:Bad login
			2:Bad login
