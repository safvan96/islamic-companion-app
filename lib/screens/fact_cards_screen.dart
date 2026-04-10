import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/app_provider.dart';
class _P{final Color bg,surface,accent,gold,fg,muted,divider;const _P({required this.bg,required this.surface,required this.accent,required this.gold,required this.fg,required this.muted,required this.divider});
  static _P of(bool d)=>d?const _P(bg:Color(0xFF0E1A19),surface:Color(0xFF182624),accent:Color(0xFF4FBFA8),gold:Color(0xFFE3C77B),fg:Color(0xFFF5F1E8),muted:Color(0xFF8B968F),divider:Color(0xFF243532)):const _P(bg:Color(0xFFF8F5EE),surface:Color(0xFFFFFFFF),accent:Color(0xFF2C7A6B),gold:Color(0xFFB8902B),fg:Color(0xFF1F2937),muted:Color(0xFF6B6359),divider:Color(0xFFE8DDD0));}
const _gradients=[[Color(0xFF1B5E20),Color(0xFF2E7D32)],[Color(0xFF0D47A1),Color(0xFF1565C0)],[Color(0xFF4A148C),Color(0xFF6A1B9A)],[Color(0xFF37474F),Color(0xFF455A64)],[Color(0xFFBF360C),Color(0xFFD84315)]];
class FactCardsScreen extends StatelessWidget{const FactCardsScreen({super.key});
  @override Widget build(BuildContext c){final isDark=Provider.of<AppProvider>(c).isDarkMode;final p=_P.of(isDark);final l=AppLocalizations.of(c)!;
    return Scaffold(backgroundColor:p.bg,appBar:AppBar(backgroundColor:Colors.transparent,elevation:0,scrolledUnderElevation:0,foregroundColor:p.fg,title:Text(l.translate('factCards'),style:TextStyle(fontSize:15,fontWeight:FontWeight.w500,color:p.muted)),centerTitle:true),
      body:PageView.builder(itemCount:15,itemBuilder:(_,i){final g=_gradients[i%_gradients.length];
        return Padding(padding:const EdgeInsets.all(24),child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[
          Container(width:double.infinity,padding:const EdgeInsets.all(32),decoration:BoxDecoration(gradient:LinearGradient(colors:g,begin:Alignment.topLeft,end:Alignment.bottomRight),borderRadius:BorderRadius.circular(24),boxShadow:[BoxShadow(color:g[0].withOpacity(0.3),blurRadius:20,offset:const Offset(0,8))]),
            child:Column(children:[Icon(Icons.lightbulb,color:Colors.white.withOpacity(0.3),size:36),const SizedBox(height:16),
              Text('#${i+1}',style:TextStyle(fontSize:14,color:Colors.white.withOpacity(0.5),fontWeight:FontWeight.w700)),const SizedBox(height:12),
              Text(l.translate('fact_${i+1}'),textAlign:TextAlign.center,style:TextStyle(fontSize:18,color:Colors.white,height:1.6,fontWeight:FontWeight.w500))])),
          const SizedBox(height:16),Text('${i+1}/15',style:TextStyle(fontSize:11,color:p.muted)),
          Text(l.translate('swipeForMore'),style:TextStyle(fontSize:10,color:p.muted.withOpacity(0.5))),
        ]));
      }),
    );
  }
}
