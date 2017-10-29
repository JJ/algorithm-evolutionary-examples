library("ggplot2")

evals.MMDP.ns1 <- data.frame( method=c(rep("ETA",length(res.afnm.MMDP.p1024.ns1.evals))
                              , rep("ETA lted",length(ECTA.book.res.ectam.MMDP.p1024.ns1.mm30.cs60.evals))
                              , rep("WPO",length(res.afnmw.MMDP.p1024.ns1.evals))
                              , rep("WPO lted", length(ECTA.book.res.lafnmw.MMDP.p1024.ns1.evals))
                              ),
                              evaluations=c(res.afnm.MMDP.p1024.ns1.evals,
                                  ECTA.book.res.ectam.MMDP.p1024.ns1.mm30.cs60.evals,
                                  res.afnmw.MMDP.p1024.ns1.evals, ECTA.book.res.lafnmw.MMDP.p1024.ns1.evals)
                              )

ggplot(evals.MMDP.ns1,aes(factor(method), evaluations))+geom_boxplot()+ scale_y_log10()
ggsave("ns1-MMDP.png",width=8,height=4.5,dpi=150)

evals.MMDP.ns2 <- data.frame( method=c(rep("ETA",length(res.afnm.MMDP.p1024.ns2.evals))
                              , rep("ETA lted",length(ECTA.book.res.ectam.MMDP.p1024.ns2.evals))
                              , rep("WPO",length(res.afnmw.MMDP.p1024.ns2.evals))
                              , rep("WPO lted", length(ECTA.book.res.lafnmw.MMDP.p1024.ns2.evals))
                              ),
                              evaluations=c(res.afnm.MMDP.p1024.ns2.evals,
                                  ECTA.book.res.ectam.MMDP.p1024.ns2.evals,
                                  res.afnmw.MMDP.p1024.ns2.evals, ECTA.book.res.lafnmw.MMDP.p1024.ns2.evals)
                              )

ggplot(evals.MMDP.ns2,aes(factor(method), evaluations))+geom_boxplot()+ scale_y_log10()
ggsave("ns2-MMDP.png",width=8,height=4.5,dpi=150)
