@chcp 65001

@rem Сборка основной разработческой ИБ. по умолчанию в каталоге build/ib
call vrunner init-dev --src src/cf %*

@rem собрать внешние обработчики и отчеты в каталоге build
@call vrunner compileepf src/epf build %*
@rem call vrunner compileepf src/erf/МойВнешнийОтчет build %*

@rem собрать расширения конфигурации внутри ИБ

@call vrunner compileext src/cfe build %*

@rem Обновление в режиме Предприятия
call vrunner run --command "ЗапуститьОбновлениеИнформационнойБазы;ЗавершитьРаботуСистемы;" --execute $runnerRoot\epf\ЗакрытьПредприятие.epf %*