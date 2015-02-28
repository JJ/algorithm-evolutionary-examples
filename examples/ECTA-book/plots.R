vs.MMDP.ns2.evals <- data.frame( limited=c(rep("no",length(res.afnmw.MMDP.p1024.ns2.evals))
                                     ,rep("yes-im1",length(ECTA.book.res.afnm.MMDP.p1024.ns2.evals))
                                     ,rep("yes-im5",length(ECTA.book.res.afnm.MMDP.p1024.ns2.cs60.rr0.5.im5.evals))),
                                evaluations=c(res.afnmw.MMDP.p1024.ns2.evals
                                    ,ECTA.book.res.afnm.MMDP.p1024.ns2.evals
                                    ,ECTA.book.res.afnm.MMDP.p1024.ns2.cs60.rr0.5.im5.evals))
ggplot(vs.MMDP.ns2.evals,aes(factor(limited), evaluations))+geom_boxplot()+ scale_y_log10()

vs.MMDP.ns2.times <- data.frame( limited=c(rep("no",length(res.afnmw.MMDP.p1024.ns2.times))
                                     ,rep("yes-im1",length(ECTA.book.res.afnm.MMDP.p1024.ns2.times))
                                     ,rep("yes-im5",length(ECTA.book.res.afnm.MMDP.p1024.ns2.cs60.rr0.5.im5.times))),
                                time=c(res.afnmw.MMDP.p1024.ns2.times
                                    ,ECTA.book.res.afnm.MMDP.p1024.ns2.times
                                    ,ECTA.book.res.afnm.MMDP.p1024.ns2.cs60.rr0.5.im5.times))

ggplot(vs.MMDP.ns2.times,aes(factor(limited), time))+geom_boxplot()+ scale_y_log10()

vs.MMDP.ns1.evals <- data.frame( limited=c(rep("no",length(res.afnmw.MMDP.p1024.ns1.evals))
                                     ,rep("yes-im1",length(ECTA.book.res.afnm.MMDP.p1024.ns1.evals))
                                     ,rep("yes-im5",length(ECTA.book.res.afnm.MMDP.p1024.ns1.cs60.rr0.5.im5.evals))),
                                evaluations=c(res.afnmw.MMDP.p1024.ns1.evals
                                    ,ECTA.book.res.afnm.MMDP.p1024.ns1.evals
                                    ,ECTA.book.res.afnm.MMDP.p1024.ns1.cs60.rr0.5.im5.evals))
ggplot(vs.MMDP.ns1.evals,aes(factor(limited), evaluations))+geom_boxplot()+ scale_y_log10()

vs.MMDP.ns1.times <- data.frame( limited=c(rep("no",length(res.afnmw.MMDP.p1024.ns1.times))
                                     ,rep("yes-im1",length(ECTA.book.res.afnm.MMDP.p1024.ns1.times))
                                     ,rep("yes-im5",length(ECTA.book.res.afnm.MMDP.p1024.ns1.cs60.rr0.5.im5.times))),
                                time=c(res.afnmw.MMDP.p1024.ns1.times
                                    ,ECTA.book.res.afnm.MMDP.p1024.ns1.times
                                    ,ECTA.book.res.afnm.MMDP.p1024.ns1.cs60.rr0.5.im5.times))

ggplot(vs.MMDP.ns1.times,aes(factor(limited), time))+geom_boxplot()+ scale_y_log10()
