set(LLVM_TARGET_DEFINITIONS ToLLVMInterface.td)
mlir_tablegen(ToLLVMAttrInterface.h.inc -gen-attr-interface-decls)
mlir_tablegen(ToLLVMAttrInterface.cpp.inc -gen-attr-interface-defs)
mlir_tablegen(ToLLVMOpInterface.h.inc -gen-op-interface-decls)
mlir_tablegen(ToLLVMOpInterface.cpp.inc -gen-op-interface-defs)
add_public_tablegen_target(MLIRConvertToLLVMInterfaceIncGen)
add_dependencies(mlir-generic-headers MLIRConvertToLLVMInterfaceIncGen)
