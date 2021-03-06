
** As throw by afPlastic.
const class PlasticErr : Err {
	internal new make(Str msg, Err? cause := null) : super(msg, cause) {}
}

** As throw by `PlasticCompiler` should Fantom code compilation fail.
const class PlasticCompilationErr : PlasticErr, SrcCodeErr {
	const override SrcCodeSnippet 	srcCode
	const override Int 				errLineNo
	const override Int 				linesOfPadding

	internal new make(SrcCodeSnippet srcCode, Int errLineNo, Str errMsg, Int linesOfPadding) : super(errMsg) {
		this.srcCode = srcCode
		this.errLineNo = errLineNo
		this.linesOfPadding = linesOfPadding
	}

	@NoDoc
	override Str toStr() {
		trace := causeStr
		trace += snippetStr
		trace += "Stack Trace:"
		return trace
	}
	
	@NoDoc
	protected Str causeStr() {
		cause == null 
			? "${typeof.qname}: ${msg}" 
			: "${cause.typeof.qname}: ${msg}"
	}

	@NoDoc
	Str snippetStr() {
		snippet := "\n${typeof.name.toDisplayName}:\n"
		snippet += toSnippetStr
		return snippet
	}
}

** A mixin for Errs that report errors in source code.
const mixin SrcCodeErr {
	
	** The source code where the error occurred.
	abstract SrcCodeSnippet	srcCode()
	
	** The line number in the source code where the error occurred. 
	abstract Int errLineNo()
	
	** How many lines of code to show on either side of the error. 
	abstract Int linesOfPadding()
	
	** The err msg
	abstract Str msg()

	Str toSnippetStr() {
		srcCode.srcCodeSnippet(errLineNo, msg, linesOfPadding)
	}
}
