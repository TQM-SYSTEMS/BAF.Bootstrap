#Область ОписаниеПеременных

// обработки
Перем КонтекстЯдра;
Перем Утверждения;

#КонецОбласти

#Область ПрограммныйИнтерфейс

Процедура Инициализация(КонтекстЯдраПараметр) Экспорт 
	
	КонтекстЯдра = КонтекстЯдраПараметр;	
	// подключение дополнительных обработок
	Утверждения = КонтекстЯдра.Плагин("БазовыеУтверждения");
	
КонецПроцедуры

Процедура ЗаполнитьНаборТестов(НаборТестов, КонтекстЯдраПараметр) Экспорт 
	
	КонтекстЯдра = КонтекстЯдраПараметр;
	
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
	
	
	НаборТестов.СтрогийПорядокВыполнения();
	
КонецПроцедуры

Процедура ПередЗапускомТеста() Экспорт 
	НачатьТранзакцию();	
КонецПроцедуры

Процедура ПослеЗапускаТеста() Экспорт	
	Если ТранзакцияАктивна() Тогда
	    ОтменитьТранзакцию();
	КонецЕсли;	
КонецПроцедуры

#КонецОбласти

#Область ЮнитТесты

Процедура ТестДолжен_ПроверитьЧтоНетПраваНаИнтерактивноеУдаление(ПолноеИмяМетаданных) Экспорт 
	
	ПроверятьОсновныеРоли = Настройки.Свойство("ПроверятьОсновныеРоли") И Настройки.ПроверятьОсновныеРоли;
	
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
	
	Утверждения.Проверить(Результат = "", "Есть право на интерактивное удаление объектов:" + Результат); 
	
КонецПроцедуры


#КонецОбласти


#Область СлужебныеПроцедурыИФункции

Функция ОбъектыМетаданных() Экспорт  
	
	Пояснение = НСтр("ru = 'Проверка права интерактивного удаления'");
	
	ОбъектыМетаданных = Новый Структура;
	ОбъектыМетаданных.Вставить("ПланыОбмена", 				Новый Массив);
	ОбъектыМетаданных.Вставить("Документы", 				Новый Массив);
	ОбъектыМетаданных.Вставить("Справочники", 				Новый Массив);
	ОбъектыМетаданных.Вставить("ПланыВидовХарактеристик", 	Новый Массив);
	ОбъектыМетаданных.Вставить("ПланыСчетов", 				Новый Массив);
	ОбъектыМетаданных.Вставить("ПланыВидовРасчета", 		Новый Массив);
	ОбъектыМетаданных.Вставить("БизнесПроцессы", 			Новый Массив);
	ОбъектыМетаданных.Вставить("Задачи", 					Новый Массив);
	
	Для Каждого Элемент Из ОбъектыМетаданных Цикл
		
		Для Каждого ОбъектМетаданных Из Метаданные[Элемент.Ключ] Цикл
			
			ИмяТеста = СтрШаблон("%1 [%2]", ОбъектМетаданных.ПолноеИмя(), Пояснение);
			
			СтруктураЭлемента = Новый Структура;
			СтруктураЭлемента.Вставить("ИмяТеста", ИмяТеста);
			СтруктураЭлемента.Вставить("ПолноеИмя", ОбъектМетаданных.ПолноеИмя());
			
			ОбъектыМетаданных[Элемент.Ключ].Добавить(СтруктураЭлемента);	
			
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат ОбъектыМетаданных;

КонецФункции  

#КонецОбласти

#Область Инициализация

Настройки = Новый Структура;

Настройки.Вставить("ПроверятьОсновныеРоли", Ложь);

#КонецОбласти
