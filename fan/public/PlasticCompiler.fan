using concurrent::AtomicInt
using compiler

** Compiles Fantom source code and afPlastic models into usable Fantom code.
const class PlasticCompiler {

	** When generating code snippets to report compilation Errs, this is the number of lines of src 
	** code the erroneous line should be padded with.  
	public const  Int 	srcCodePadding		:= 5 
	
	** static because pods are shared throughout the JVM, not just the IoC 
	private static const AtomicInt podIndex	:= AtomicInt(1)
	
	** Creates a 'PlasticCompiler'.
	new make(|This|? in := null) { in?.call(this) }
	
	** Compiles the given class model into a pod and returns the associated Fantom type.
	Type compileModel(PlasticClassModel model) {
		pod		:= compileCode(model.toFantomCode)
		type	:= pod.type(model.className)
		return type
	}
	
	** Compiles the given Fantom code into a pod. 
	** If no pod name is given, a unique one will be generated.
	Pod compileCode(Str fantomPodCode, Str? podName := null) {

		podName = podName ?: generatePodName
		
		try {
			input 		    := CompilerInput()
			input.podName 	= podName
	 		input.summary 	= "Alien-Factory Transient Pod"
			input.version 	= Version.defVal
			input.log.level = LogLevel.warn
			input.isScript 	= true
			input.output 	= CompilerOutputMode.transientPod
			input.mode 		= CompilerInputMode.str
			input.srcStrLoc	= Loc(podName)
			input.srcStr 	= fantomPodCode
	
			compiler 		:= Compiler(input)
			pod 			:= compiler.compile.transientPod
			return pod

		} catch (CompilerErr err) {
			srcCode := SrcCodeSnippet(`${podName}`, fantomPodCode)
			throw PlasticCompilationErr(srcCode, err.line, err.msg, srcCodePadding)
		}
	}
	
	** Different pod names prevents "sys::Err: Duplicate pod name: <podName>".
	** We internalise podName so we can guarantee no duplicate pod names
	Str generatePodName() {
		index := podIndex.getAndIncrement.toStr.padl(3, '0')
		
		// TODO: afIoc used afPlasticPod!!!
//		return "afPlasticPod${index}"
		
		return "afPlastic${index}"
	}
}

