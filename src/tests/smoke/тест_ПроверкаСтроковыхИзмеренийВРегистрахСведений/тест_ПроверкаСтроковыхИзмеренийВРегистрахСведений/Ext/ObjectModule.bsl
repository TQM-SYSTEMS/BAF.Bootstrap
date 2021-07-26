﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

// обработки
Перем КонтекстЯдра;
Перем Утверждения;
Перем Ожидаем;

#КонецОбласти

#Область ПрограммныйИнтерфейс

Процедура Инициализация(КонтекстЯдраПараметр) Экспорт 
	
	КонтекстЯдра = КонтекстЯдраПараметр;	
	// подключение дополнительных обработок
	Утверждения = КонтекстЯдра.Плагин("БазовыеУтверждения");
	Ожидаем = КонтекстЯдра.Плагин("УтвержденияBDD");
	
КонецПроцедуры

// Процедура - Заполнить набор тестов
//
// Параметры:
//  НаборТестов			 - 	 - 
//  КонтекстЯдраПараметр - 	 - 
//
Процедура ЗаполнитьНаборТестов(НаборТестов, КонтекстЯдраПараметр) Экспорт 
	
	КонтекстЯдра = КонтекстЯдраПараметр;
	ДобавитьРегистрамиСведений(НаборТестов);
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

Процедура ДобавитьРегистрамиСведений(НаборТестов)
	
	Регистры = Регистры("TQM", Истина);
	Для Каждого КлючЗначение Из Регистры Цикл
		
		МассивТестов = КлючЗначение.Значение;
		
		Если МассивТестов.Количество() Тогда
			НаборТестов.НачатьГруппу(КлючЗначение.Ключ, Истина);
		КонецЕсли;
		
		Для Каждого Тест Из МассивТестов Цикл
			
			ИмяПроцедуры = "ТестДолжен_ПроверитьРегистр";
			ТекстПояснения = НСтр("ru = 'Проверка регистра на ограничение длины индекса файловой базы (строковые измерения)'");
			ИмяТеста = КонтекстЯдра.СтрШаблон_("%1 [%2]", Тест.ПолноеИмя, ТекстПояснения); 
			НаборТестов.Добавить( ИмяПроцедуры, НаборТестов.ПараметрыТеста(Тест.Имя, Тест.ПолноеИмя), ИмяТеста );
			
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры


#КонецОбласти

#Область ЮнитТесты

// Процедура - Тест должен проверить регистр
//
// Параметры:
//  ИмяРегистра			 - 	 - 
//  ПолноеИмяРегистра	 - 	 - 
//
Процедура ТестДолжен_ПроверитьРегистр(ИмяРегистра, ПолноеИмяРегистра) Экспорт 
	
	Регистр = Метаданные.НайтиПоПолномуИмени(ПолноеИмяРегистра);
	
	ОграничениеДлиныИндексаФайловойБазы = ОграничениеДлиныИндексаФайловойБазы();
	ДлинаСтроки = РазмерБайтСтроковыхИзмерений(ДлинаСтрокиИзмерений(Регистр.Измерения));
	
	Утверждения.Проверить(
		ДлинаСтроки < ОграничениеДлиныИндексаФайловойБазы, 
		СтрШаблон("Суммарная длина строк измерений регистра [%1] превышает допустимую длину [%2 байт] для файловой базы", 
		ПолноеИмяРегистра, ОграничениеДлиныИндексаФайловойБазы));	
	
КонецПроцедуры


#КонецОбласти 

#Область СлужебныйПрограммныйИнтерфейс
// Код процедур и функций
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ОграничениеДлиныИндексаФайловойБазы()
	
	Возврат 1920; // байт
	
КонецФункции

Функция РазмерБайтСтроковыхИзмерений(ДлинаСтроки)
	
	Возврат (ДлинаСтроки * 3) + 2;
	
КонецФункции

Функция ДлинаСтрокиИзмерений(Измерения)
	
	Длина = 0;
	
	Для каждого ЭлементКоллекции Из Измерения Цикл
		
		Длина = Длина + ЭлементКоллекции.Тип.КвалификаторыСтроки.Длина;
		
	КонецЦикла; 
	
	Возврат Длина;
	
КонецФункции

Функция Регистры(ПрефиксОбъектов, ОтборПоПрефиксу)
	
	Регистры = Новый Соответствие;
	Регистры.Вставить("РегистрыСведений", Новый Массив);
	
	Для Каждого КлючЗначение Из Регистры Цикл
		Для Каждого Регистр Из Метаданные[КлючЗначение.Ключ] Цикл
			Если ОтборПоПрефиксу И Не ИмяСодержитПрефикс(Регистр.Имя, ПрефиксОбъектов) Тогда
				Продолжить;
			КонецЕсли;
			
			СтруктураРегистра = Новый Структура;
			СтруктураРегистра.Вставить("Имя", Регистр.Имя);
			СтруктураРегистра.Вставить("Синоним", Регистр.Синоним);
			СтруктураРегистра.Вставить("ПолноеИмя", Регистр.ПолноеИмя());
			
			КлючЗначение.Значение.Добавить( СтруктураРегистра );
			
		КонецЦикла;	
	КонецЦикла;
	
	Возврат Регистры;

КонецФункции 

Функция ИмяСодержитПрефикс(Имя, Префикс)
	
	Если Не ЗначениеЗаполнено(Префикс) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ДлинаПрефикса = СтрДлина(Префикс);
	Возврат СтрНайти(ВРег(Лев(Имя, ДлинаПрефикса)), Префикс) > 0;
	
КонецФункции



#КонецОбласти

#Область Инициализация

#КонецОбласти
    
#Иначе
 ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли