import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/app_provider.dart';

class _P {
  final Color bg, surface, accent, gold, fg, muted, divider;
  const _P({required this.bg, required this.surface, required this.accent, required this.gold, required this.fg, required this.muted, required this.divider});
  static _P of(bool d) => d
      ? const _P(bg: Color(0xFF0E1A19), surface: Color(0xFF182624), accent: Color(0xFF4FBFA8), gold: Color(0xFFE3C77B), fg: Color(0xFFF5F1E8), muted: Color(0xFF8B968F), divider: Color(0xFF243532))
      : const _P(bg: Color(0xFFF8F5EE), surface: Color(0xFFFFFFFF), accent: Color(0xFF2C7A6B), gold: Color(0xFFB8902B), fg: Color(0xFF1F2937), muted: Color(0xFF6B6359), divider: Color(0xFFE8DDD0));
}
const _phases = [('\u0633\u0628\u062d\u0627\u0646 \u0627\u0644\u0644\u0647','SubhanAllah',33),('\u0627\u0644\u062d\u0645\u062f \u0644\u0644\u0647','Alhamdulillah',33),('\u0627\u0644\u0644\u0647 \u0623\u0643\u0628\u0631','Allahu Akbar',34)];
class TasbihatCounterScreen extends StatefulWidget { const TasbihatCounterScreen({super.key}); @override State<TasbihatCounterScreen> createState() => _S(); }
class _S extends State<TasbihatCounterScreen> {
  int _ph=0,_c=0; bool _done=false;
  void _tap(){if(_done)return;HapticFeedback.lightImpact();setState((){_c++;if(_c>=_phases[_ph].$3){if(_ph<2){_ph++;_c=0;}else{_done=true;HapticFeedback.heavyImpact();}}});}
  void _reset()=>setState((){_ph=0;_c=0;_done=false;});
  @override Widget build(BuildContext c){final isDark=Provider.of<AppProvider>(c).isDarkMode;final p=_P.of(isDark);final l=AppLocalizations.of(c)!;
    final g=_ph==0?_c:_ph==1?33+_c:_done?100:66+_c;final pr=g/100;
    return Scaffold(backgroundColor:p.bg,appBar:AppBar(backgroundColor:Colors.transparent,elevation:0,scrolledUnderElevation:0,foregroundColor:p.fg,title:Text(l.translate('tasbihatCounter'),style:TextStyle(fontSize:15,fontWeight:FontWeight.w500,color:p.muted)),centerTitle:true,actions:[IconButton(icon:Icon(Icons.refresh,color:p.muted,size:20),onPressed:_reset)]),
      body:GestureDetector(behavior:HitTestBehavior.opaque,onTap:_tap,child:SafeArea(child:Column(children:[
        const Spacer(flex:1),
        Row(mainAxisAlignment:MainAxisAlignment.center,children:List.generate(3,(i)=>Container(margin:const EdgeInsets.symmetric(horizontal:6),width:i==_ph?28:10,height:10,decoration:BoxDecoration(color:i<_ph?p.gold:i==_ph?p.accent:p.divider,borderRadius:BorderRadius.circular(5))))),
        const SizedBox(height:16),
        if(!_done)...[Text(_phases[_ph].$1,textDirection:TextDirection.rtl,style:TextStyle(fontSize:32,color:p.fg)),const SizedBox(height:4),Text(_phases[_ph].$2,style:TextStyle(fontSize:14,color:p.muted))]
        else...[Icon(Icons.check_circle,size:48,color:p.gold),const SizedBox(height:8),Text('100/100',style:TextStyle(fontSize:20,fontWeight:FontWeight.w600,color:p.gold))],
        const Spacer(flex:1),
        SizedBox(width:200,height:200,child:Stack(alignment:Alignment.center,children:[SizedBox(width:200,height:200,child:CircularProgressIndicator(value:pr,strokeWidth:6,strokeCap:StrokeCap.round,backgroundColor:p.divider,valueColor:AlwaysStoppedAnimation(_done?p.gold:p.accent))),Text(_done?'100':'$_c',style:TextStyle(fontSize:64,fontWeight:FontWeight.w200,color:p.fg))])),
        if(!_done)...[const SizedBox(height:8),Text('/ ${_phases[_ph].$3}',style:TextStyle(fontSize:14,color:p.muted))],
        const Spacer(flex:1),
        Text('$g / 100',style:TextStyle(fontSize:12,color:p.muted)),
        Padding(padding:const EdgeInsets.symmetric(horizontal:40,vertical:8),child:ClipRRect(borderRadius:BorderRadius.circular(3),child:LinearProgressIndicator(value:pr,minHeight:4,backgroundColor:p.divider,valueColor:AlwaysStoppedAnimation(p.gold)))),
        const SizedBox(height:16),
      ]))));
  }
}
