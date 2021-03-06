#Область ОписаниеПеременных

&НаКлиенте
Перем КонтекстЯдра;
&НаКлиенте
Перем Утверждения;
&НаКлиенте
Перем СтроковыеУтилиты;
&НаКлиенте
Перем Настройки;

#КонецОбласти

#Область ИнтерфейсТестирования

&НаКлиенте
Процедура Инициализация(КонтекстЯдраПараметр) Экспорт
	
	КонтекстЯдра = КонтекстЯдраПараметр;
	Утверждения = КонтекстЯдра.Плагин("БазовыеУтверждения");
	СтроковыеУтилиты = КонтекстЯдра.Плагин("СтроковыеУтилиты");
	Настройки = Объект.Настройки;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьНаборТестов(НаборТестов, КонтекстЯдраПараметр) Экспорт
	
	Инициализация(КонтекстЯдраПараметр);
	ОбъектыМетаданных = ОбъектыМетаданных();
	
	Для Каждого ОбъектМетаданных Из ОбъектыМетаданных Цикл
		
		Если ОбъектМетаданных.Значение.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		НаборТестов.НачатьГруппу(ОбъектМетаданных.Ключ, Ложь);
		Для Каждого Элемент Из ОбъектМетаданных.Значение Цикл
			НаборТестов.Добавить(
				"ТестДолжен_ПроверитьЧтоНетПраваНаИнтерактивноеУдаление", 
				НаборТестов.ПараметрыТеста(Элемент.ПолноеИмя), 
				Элемент.ИмяТеста);	
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ЮнитТесты

&НаКлиенте
Процедура ТестДолжен_ПроверитьЧтоНетПраваНаИнтерактивноеУдаление(ПолноеИмяМетаданных) Экспорт 
	
	Результат = "";
	ПроверятьОсновныеРоли = Настройки.Свойство("ПроверятьОсновныеРоли") И Настройки.ПроверятьОсновныеРоли;
	Результат = ТестДолжен_ПроверитьЧтоНетПраваНаИнтерактивноеУдалениеСервер(ПолноеИмяМетаданных, ПроверятьОсновныеРоли);
	
	Утверждения.Проверить(Результат = "", "Есть право на интерактивное удаление объектов:" + Результат); 		
		
КонецПроцедуры

&НаСервереБезКонтекста
Функция ТестДолжен_ПроверитьЧтоНетПраваНаИнтерактивноеУдалениеСервер(ПолноеИмяМетаданных, ПроверятьОсновныеРоли)
		
	ОбъектМетаданных = Метаданные.НайтиПоПолномуИмени(ПолноеИмяМетаданных);
	
	ЕстьПраво = Ложь;
	
	Результат = "";
	
	Для Каждого Роль Из Метаданные.Роли Цикл
		
		Если Не ПроверятьОсновныеРоли И Метаданные.ОсновныеРоли.Содержит(Роль) Тогда
			Продолжить;
		КонецЕсли;
		
		ЕстьПраво = ПравоДоступа("ИнтерактивноеУдаление", ОбъектМетаданных, Роль);
		
		Если ЕстьПраво Тогда
			Результат = Результат + Символы.ПС + Роль.Имя +", ПолноеИмяМетаданных: "+ПолноеИмяМетаданных;
		КонецЕсли;
		
	КонецЦикла;

	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции 

&НаСервере	
Функция ОбъектыМетаданных()
	Возврат РеквизитФормыВЗначение("Объект").ОбъектыМетаданных();
КонецФункции


&НаСервереБезКонтекста
Функция СтроковыеУтилиты()
	Возврат ВнешниеОбработки.Создать("СтроковыеУтилиты");	
КонецФункции 


#КонецОбласти