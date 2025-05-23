; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; dbg.value intrinsics should not affect peephole combining of stacksave/stackrestore.
; PR37713
; RUN: opt -passes=instcombine %s -S | FileCheck %s

declare ptr @llvm.stacksave() #0
declare void @llvm.stackrestore(ptr) #0

define ptr @test1(i32 %P) !dbg !6 {
; CHECK-LABEL: @test1(
; CHECK-NEXT:      #dbg_value(ptr poison, [[META9:![0-9]+]], !DIExpression(), [[META12:![0-9]+]])
; CHECK-NEXT:    [[TMP1:%.*]] = zext i32 [[P:%.*]] to i64, !dbg [[DBG13:![0-9]+]]
; CHECK-NEXT:    [[A:%.*]] = alloca i32, i64 [[TMP1]], align 4, !dbg [[DBG13]]
; CHECK-NEXT:      #dbg_value(ptr [[A]], [[META11:![0-9]+]], !DIExpression(), [[DBG13]])
; CHECK-NEXT:    ret ptr [[A]], !dbg [[DBG14:![0-9]+]]
;
  %tmp = call ptr @llvm.stacksave(), !dbg !12
  call void @llvm.dbg.value(metadata ptr %tmp, metadata !9, metadata !DIExpression()), !dbg !12
  call void @llvm.stackrestore(ptr %tmp), !dbg !13
  %A = alloca i32, i32 %P, !dbg !14
  call void @llvm.dbg.value(metadata ptr %A, metadata !11, metadata !DIExpression()), !dbg !14
  ret ptr %A, !dbg !15
}

declare void @llvm.dbg.value(metadata, metadata, metadata) #1
attributes #0 = { nounwind }
attributes #1 = { nounwind readnone speculatable }

!llvm.dbg.cu = !{!0}
!llvm.debugify = !{!3, !4}
!llvm.module.flags = !{!5}

!0 = distinct !DICompileUnit(language: DW_LANG_C, file: !1, producer: "debugify", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !2)
!1 = !DIFile(filename: "patatino.ll", directory: "/")
!2 = !{}
!3 = !{i32 4}
!4 = !{i32 2}
!5 = !{i32 2, !"Debug Info Version", i32 3}
!6 = distinct !DISubprogram(name: "test1", linkageName: "test1", scope: null, file: !1, line: 1, type: !7, isLocal: false, isDefinition: true, scopeLine: 1, isOptimized: true, unit: !0, retainedNodes: !8)
!7 = !DISubroutineType(types: !2)
!8 = !{!9, !11}
!9 = !DILocalVariable(name: "1", scope: !6, file: !1, line: 1, type: !10)
!10 = !DIBasicType(name: "ty64", size: 64, encoding: DW_ATE_unsigned)
!11 = !DILocalVariable(name: "2", scope: !6, file: !1, line: 3, type: !10)
!12 = !DILocation(line: 1, column: 1, scope: !6)
!13 = !DILocation(line: 2, column: 1, scope: !6)
!14 = !DILocation(line: 3, column: 1, scope: !6)
!15 = !DILocation(line: 4, column: 1, scope: !6)
