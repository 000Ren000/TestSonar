﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

#Область КомандыПодменюОтчеты

// Добавляет команду отчета в список команд.
// 
// Параметры:
//   КомандыОтчетов - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.КомандыОтчетов
// Возвращаемое значение:
//   СтрокаТаблицыЗначений - новая команда отчета.
Функция ДобавитьКомандуОтчета(КомандыОтчетов) Экспорт

	Если ПравоДоступа("Просмотр", Метаданные.Отчеты.ОстаткиТоваровОрганизаций) 
			И ПолучитьФункциональнуюОпцию("ИспользоватьПередачиТоваровМеждуОрганизациями") Тогда
		
		КомандаОтчет = КомандыОтчетов.Добавить();
		
		КомандаОтчет.Менеджер = Метаданные.Отчеты.ОстаткиТоваровОрганизаций.ПолноеИмя();
		КомандаОтчет.Представление = НСтр("ru = 'Остатки товаров организаций'");
		КомандаОтчет.МножественныйВыбор = Ложь;
		КомандаОтчет.Важность = "Обычное";
		
		Возврат КомандаОтчет;
		
	КонецЕсли;

	Возврат Неопределено;

КонецФункции

#КонецОбласти

#КонецОбласти
		
#КонецЕсли