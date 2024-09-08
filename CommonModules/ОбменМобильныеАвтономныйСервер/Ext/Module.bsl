﻿#Если МобильныйАвтономныйСервер Тогда
#Область ПрограммныйИнтерфейс

// Сервисная функция для начальной инициализации БД, проверяет что синхронизация данных ранее не проводилась
// Возвращаемое значение:
//	Структура - коллекция, которая содержит следующие свойства:
//		* КодУзлаОбмена - Строка - код узла .
//
Функция ДанныеДляПроверки() Экспорт
	
	Узел = ПланыОбмена.Мобильные.ЭтотУзел();
	КодУзла = Узел["Код"];
	
	СтруктураВозврата = Новый Структура();
	СтруктураВозврата.Вставить("КодУзлаОбмена", КодУзла);
	Возврат СтруктураВозврата;
	
КонецФункции

// Сервисная функция для получения константы
// Возвращаемое значение:
//	Структура - коллекция, которая содержит следующие свойства:
//		* Принято - Число - ПринятоЗаписей .
//		* Отправлено - Число - ОтправленоЗаписей .
//
&НаСервере
Функция ПринятоОтправленоНовыхЗаписей() Экспорт
	
	СтруктураВозврата = Новый Структура();
	СтруктураВозврата.Вставить("Принято", Константы.ПринятоЗаписей.Получить());
	СтруктураВозврата.Вставить("Отправлено", Константы.ОтправленоЗаписей.Получить());
	Возврат СтруктураВозврата;
	
КонецФункции

// Процедура выполняет синхронизацию данных с основной базой. через опубликованный ею веб-сервис
Процедура ВыполнитьОбменДанными() Экспорт
	
	НаименованиеУзла = "Автономный узел";
	
	ЦентральныйУзелОбмена = ПланыОбмена.Мобильные.НайтиПоКоду("001");
	Если ЦентральныйУзелОбмена.Пустая() Тогда
		
		НовыйУзел = ПланыОбмена.Мобильные.СоздатьУзел();
		НовыйУзел.Код = "001";
		НовыйУзел.Наименование = НСтр("ru='Центральный'");
		НовыйУзел.Записать();
		ЦентральныйУзелОбмена = НовыйУзел.Ссылка;
		
	КонецЕсли;
	
	Узел = ПланыОбмена.Мобильные.ЭтотУзел();
	КодУзла = Узел["Код"];
	
	// Инициализируем обмен, проверяем, есть ли нужный узел в плане обмена.
	НовыйКод = ОсновнойСервер.ОбменМобильныеВызовПК.НачатьОбмен(КодУзла,
		НаименованиеУзла,
		ЦентральныйУзелОбмена["НомерПринятого"],
		ЦентральныйУзелОбмена["НомерОтправленного"]);
	
	Если КодУзла <> НовыйКод Тогда
		
		ОбъектУзла = Узел.ПолучитьОбъект();
		ОбъектУзла.Код = НовыйКод;
		ОбъектУзла.Наименование = НаименованиеУзла;
		ОбъектУзла.Записать();
		
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	Константы.ОтправленоЗаписей.Установить(0);
	Константы.ПринятоЗаписей.Установить(0);
	УстановитьПривилегированныйРежим(Ложь);
	
	ДанныеОбмена = ОбменМобильныеОбщее.СформироватьПакетОбмена(ЦентральныйУзелОбмена);
	ДанныеОбмена = ОсновнойСервер.ОбменМобильныеВызовПК.ВыполнитьОбменДанными(КодУзла, ДанныеОбмена);
	ОбменМобильныеОбщее.ПринятьПакетОбмена(ЦентральныйУзелОбмена, ДанныеОбмена);
	
КонецПроцедуры

// Функция проверки завершенности фонового задания
// Функция анализирует состояние фонового задания и информацию
// о возникших ошибках
//
// Параметры:
//  Идентификатор - УникальныйИдентификатор - идентификатор фонового задания
//  ТекстОшибки - Строка - параметр для возврата информации об ошибках
//
// Возвращаемое значение:
//  Булево - Истина, если задание завершено
//
Функция ОбменДаннымиЗакончен(Идентификатор, ТекстОшибки) Экспорт
	
	ТекстОшибки = "";
	
	Если ТипЗнч(Идентификатор) <> Тип("УникальныйИдентификатор") Тогда
		Возврат Истина;
	КонецЕсли;

	Задание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(Идентификатор);
	Если Задание = Неопределено Тогда
		Возврат Истина; // вероятно, уже вытеснено из памяти
	КонецЕсли;
	
	Если Задание.Состояние = СостояниеФоновогоЗадания.Активно Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если Задание.Состояние = СостояниеФоновогоЗадания.ЗавершеноАварийно Тогда
		ТекстОшибки = Задание.ИнформацияОбОшибке.Описание;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

// Функция запускает фоновое задание для синхронизации данных
// Возвращаемое значение:
//  УникальныйИдентификатор
//
Функция ВыполнитьОбменДаннымиВФоне() Экспорт
	
	Задание = ФоновыеЗадания.Выполнить("ОбменМобильныеАвтономныйСервер.ВыполнитьОбменДанными",,, "Синхронизация");
	Возврат Задание.УникальныйИдентификатор;
	
КонецФункции

#КонецОбласти
#КонецЕсли
