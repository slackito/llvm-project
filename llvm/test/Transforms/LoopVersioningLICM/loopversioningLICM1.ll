; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -S -passes='default<O1>,function(loop-versioning-licm,loop-mssa(licm))' -debug-only=loop-versioning-licm 2>&1 | FileCheck %s
; REQUIRES: asserts
;
; Test to confirm loop is a candidate for LoopVersioningLICM.
; It also confirms invariant moved out of loop.
;
; CHECK: Loop: Loop at depth 2 containing: %for.body3<header><latch><exiting>
; CHECK-NEXT:   Loop Versioning found to be beneficial

define i32 @foo(ptr nocapture %var1, ptr nocapture readnone %var2, ptr nocapture %var3, i32 %itr) #0 {
; CHECK-LABEL: @foo(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP14:%.*]] = icmp eq i32 [[ITR:%.*]], 0
; CHECK-NEXT:    br i1 [[CMP14]], label [[FOR_END13:%.*]], label [[FOR_COND1_PREHEADER_PREHEADER:%.*]]
; CHECK:       for.cond1.preheader.preheader:
; CHECK-NEXT:    [[SCEVGEP1:%.*]] = getelementptr i8, ptr [[VAR1:%.*]], i64 4
; CHECK-NEXT:    [[TMP0:%.*]] = add i32 [[ITR]], -1
; CHECK-NEXT:    br label [[FOR_COND1_PREHEADER:%.*]]
; CHECK:       for.cond1.preheader:
; CHECK-NEXT:    [[INDVAR:%.*]] = phi i64 [ 0, [[FOR_COND1_PREHEADER_PREHEADER]] ], [ [[INDVAR_NEXT:%.*]], [[FOR_INC11:%.*]] ]
; CHECK-NEXT:    [[J_016:%.*]] = phi i32 [ [[J_1_LCSSA:%.*]], [[FOR_INC11]] ], [ 0, [[FOR_COND1_PREHEADER_PREHEADER]] ]
; CHECK-NEXT:    [[I_015:%.*]] = phi i32 [ [[INC12:%.*]], [[FOR_INC11]] ], [ 0, [[FOR_COND1_PREHEADER_PREHEADER]] ]
; CHECK-NEXT:    [[TMP1:%.*]] = shl nuw nsw i64 [[INDVAR]], 2
; CHECK-NEXT:    [[SCEVGEP3:%.*]] = getelementptr i8, ptr [[VAR3:%.*]], i64 [[TMP1]]
; CHECK-NEXT:    [[TMP2:%.*]] = add i64 [[TMP1]], 4
; CHECK-NEXT:    [[SCEVGEP4:%.*]] = getelementptr i8, ptr [[VAR3]], i64 [[TMP2]]
; CHECK-NEXT:    [[CMP212:%.*]] = icmp ult i32 [[J_016]], [[ITR]]
; CHECK-NEXT:    br i1 [[CMP212]], label [[FOR_BODY3_LVER_CHECK:%.*]], label [[FOR_INC11]]
; CHECK:       for.body3.lver.check:
; CHECK-NEXT:    [[ADD:%.*]] = add i32 [[I_015]], [[ITR]]
; CHECK-NEXT:    [[IDXPROM6:%.*]] = zext i32 [[I_015]] to i64
; CHECK-NEXT:    [[ARRAYIDX7:%.*]] = getelementptr inbounds nuw i32, ptr [[VAR3]], i64 [[IDXPROM6]]
; CHECK-NEXT:    [[TMP3:%.*]] = zext i32 [[J_016]] to i64
; CHECK-NEXT:    [[TMP4:%.*]] = shl nuw nsw i64 [[TMP3]], 2
; CHECK-NEXT:    [[SCEVGEP:%.*]] = getelementptr i8, ptr [[VAR1]], i64 [[TMP4]]
; CHECK-NEXT:    [[TMP5:%.*]] = sub i32 [[TMP0]], [[J_016]]
; CHECK-NEXT:    [[TMP6:%.*]] = zext i32 [[TMP5]] to i64
; CHECK-NEXT:    [[TMP7:%.*]] = shl nuw nsw i64 [[TMP6]], 2
; CHECK-NEXT:    [[TMP8:%.*]] = add i64 [[TMP4]], [[TMP7]]
; CHECK-NEXT:    [[SCEVGEP2:%.*]] = getelementptr i8, ptr [[SCEVGEP1]], i64 [[TMP8]]
; CHECK-NEXT:    [[BOUND0:%.*]] = icmp ult ptr [[SCEVGEP]], [[SCEVGEP4]]
; CHECK-NEXT:    [[BOUND1:%.*]] = icmp ult ptr [[SCEVGEP3]], [[SCEVGEP2]]
; CHECK-NEXT:    [[FOUND_CONFLICT:%.*]] = and i1 [[BOUND0]], [[BOUND1]]
; CHECK-NEXT:    br i1 [[FOUND_CONFLICT]], label [[FOR_BODY3_PH_LVER_ORIG:%.*]], label [[FOR_BODY3_PH:%.*]]
; CHECK:       for.body3.ph.lver.orig:
; CHECK-NEXT:    br label [[FOR_BODY3_LVER_ORIG:%.*]]
; CHECK:       for.body3.lver.orig:
; CHECK-NEXT:    [[J_113_LVER_ORIG:%.*]] = phi i32 [ [[J_016]], [[FOR_BODY3_PH_LVER_ORIG]] ], [ [[INC_LVER_ORIG:%.*]], [[FOR_BODY3_LVER_ORIG]] ]
; CHECK-NEXT:    [[IDXPROM_LVER_ORIG:%.*]] = zext i32 [[J_113_LVER_ORIG]] to i64
; CHECK-NEXT:    [[ARRAYIDX_LVER_ORIG:%.*]] = getelementptr inbounds nuw i32, ptr [[VAR1]], i64 [[IDXPROM_LVER_ORIG]]
; CHECK-NEXT:    store i32 [[ADD]], ptr [[ARRAYIDX_LVER_ORIG]], align 4
; CHECK-NEXT:    [[TMP9:%.*]] = load i32, ptr [[ARRAYIDX7]], align 4
; CHECK-NEXT:    [[ADD8_LVER_ORIG:%.*]] = add nsw i32 [[TMP9]], [[ADD]]
; CHECK-NEXT:    store i32 [[ADD8_LVER_ORIG]], ptr [[ARRAYIDX7]], align 4
; CHECK-NEXT:    [[INC_LVER_ORIG]] = add nuw i32 [[J_113_LVER_ORIG]], 1
; CHECK-NEXT:    [[CMP2_LVER_ORIG:%.*]] = icmp ult i32 [[INC_LVER_ORIG]], [[ITR]]
; CHECK-NEXT:    br i1 [[CMP2_LVER_ORIG]], label [[FOR_BODY3_LVER_ORIG]], label [[FOR_INC11_LOOPEXIT_LOOPEXIT:%.*]], !llvm.loop [[LOOP0:![0-9]+]]
; CHECK:       for.body3.ph:
; CHECK-NEXT:    [[ARRAYIDX7_PROMOTED:%.*]] = load i32, ptr [[ARRAYIDX7]], align 4, !alias.scope [[META2:![0-9]+]]
; CHECK-NEXT:    br label [[FOR_BODY3:%.*]]
; CHECK:       for.body3:
; CHECK-NEXT:    [[ADD86:%.*]] = phi i32 [ [[ARRAYIDX7_PROMOTED]], [[FOR_BODY3_PH]] ], [ [[ADD8:%.*]], [[FOR_BODY3]] ]
; CHECK-NEXT:    [[J_113:%.*]] = phi i32 [ [[J_016]], [[FOR_BODY3_PH]] ], [ [[INC:%.*]], [[FOR_BODY3]] ]
; CHECK-NEXT:    [[IDXPROM:%.*]] = zext i32 [[J_113]] to i64
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds nuw i32, ptr [[VAR1]], i64 [[IDXPROM]]
; CHECK-NEXT:    store i32 [[ADD]], ptr [[ARRAYIDX]], align 4, !alias.scope [[META5:![0-9]+]], !noalias [[META2]]
; CHECK-NEXT:    [[ADD8]] = add nsw i32 [[ADD86]], [[ADD]]
; CHECK-NEXT:    [[INC]] = add nuw i32 [[J_113]], 1
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ult i32 [[INC]], [[ITR]]
; CHECK-NEXT:    br i1 [[CMP2]], label [[FOR_BODY3]], label [[FOR_INC11_LOOPEXIT_LOOPEXIT5:%.*]], !llvm.loop [[LOOP7:![0-9]+]]
; CHECK:       for.inc11.loopexit.loopexit:
; CHECK-NEXT:    br label [[FOR_INC11_LOOPEXIT:%.*]]
; CHECK:       for.inc11.loopexit.loopexit5:
; CHECK-NEXT:    [[ADD8_LCSSA:%.*]] = phi i32 [ [[ADD8]], [[FOR_BODY3]] ]
; CHECK-NEXT:    store i32 [[ADD8_LCSSA]], ptr [[ARRAYIDX7]], align 4, !alias.scope [[META2]]
; CHECK-NEXT:    br label [[FOR_INC11_LOOPEXIT]]
; CHECK:       for.inc11.loopexit:
; CHECK-NEXT:    br label [[FOR_INC11]]
; CHECK:       for.inc11:
; CHECK-NEXT:    [[J_1_LCSSA]] = phi i32 [ [[J_016]], [[FOR_COND1_PREHEADER]] ], [ [[ITR]], [[FOR_INC11_LOOPEXIT]] ]
; CHECK-NEXT:    [[INC12]] = add nuw i32 [[I_015]], 1
; CHECK-NEXT:    [[CMP:%.*]] = icmp ult i32 [[INC12]], [[ITR]]
; CHECK-NEXT:    [[INDVAR_NEXT]] = add i64 [[INDVAR]], 1
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_COND1_PREHEADER]], label [[FOR_END13_LOOPEXIT:%.*]]
; CHECK:       for.end13.loopexit:
; CHECK-NEXT:    br label [[FOR_END13]]
; CHECK:       for.end13:
; CHECK-NEXT:    ret i32 0
;
entry:
  %cmp14 = icmp eq i32 %itr, 0
  br i1 %cmp14, label %for.end13, label %for.cond1.preheader.preheader

for.cond1.preheader.preheader:                    ; preds = %entry
  br label %for.cond1.preheader

for.cond1.preheader:                              ; preds = %for.cond1.preheader.preheader, %for.inc11
  %j.016 = phi i32 [ %j.1.lcssa, %for.inc11 ], [ 0, %for.cond1.preheader.preheader ]
  %i.015 = phi i32 [ %inc12, %for.inc11 ], [ 0, %for.cond1.preheader.preheader ]
  %cmp212 = icmp ult i32 %j.016, %itr
  br i1 %cmp212, label %for.body3.lr.ph, label %for.inc11

for.body3.lr.ph:                                  ; preds = %for.cond1.preheader
  %add = add i32 %i.015, %itr
  %idxprom6 = zext i32 %i.015 to i64
  %arrayidx7 = getelementptr inbounds i32, ptr %var3, i64 %idxprom6
  br label %for.body3

for.body3:                                        ; preds = %for.body3.lr.ph, %for.body3
  %j.113 = phi i32 [ %j.016, %for.body3.lr.ph ], [ %inc, %for.body3 ]
  %idxprom = zext i32 %j.113 to i64
  %arrayidx = getelementptr inbounds i32, ptr %var1, i64 %idxprom
  store i32 %add, ptr %arrayidx, align 4
  %0 = load i32, ptr %arrayidx7, align 4
  %add8 = add nsw i32 %0, %add
  store i32 %add8, ptr %arrayidx7, align 4
  %inc = add nuw i32 %j.113, 1
  %cmp2 = icmp ult i32 %inc, %itr
  br i1 %cmp2, label %for.body3, label %for.inc11.loopexit

for.inc11.loopexit:                               ; preds = %for.body3
  br label %for.inc11

for.inc11:                                        ; preds = %for.inc11.loopexit, %for.cond1.preheader
  %j.1.lcssa = phi i32 [ %j.016, %for.cond1.preheader ], [ %itr, %for.inc11.loopexit ]
  %inc12 = add nuw i32 %i.015, 1
  %cmp = icmp ult i32 %inc12, %itr
  br i1 %cmp, label %for.cond1.preheader, label %for.end13.loopexit

for.end13.loopexit:                               ; preds = %for.inc11
  br label %for.end13

for.end13:                                        ; preds = %for.end13.loopexit, %entry
  ret i32 0
}

