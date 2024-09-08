﻿
#Область ПрограммныйИнтерфейс

// Формирует назначение платежа по КБК
//
// Параметры:
//    КБК - Строка - КБК
//
// Возвращаемое значение:
//    Строка - Назначение платежа.
//
Функция НазначениеПлатежаПоКБК(КБК) Экспорт
	
	НазначениеПлатежаПоКБК = "";
	
	КлассификаторДоходовБюджетов2015 = КлассификаторДоходовБюджетов2015();
	
	Отбор = Новый Структура("Код", КБК);
	НайденныеСтроки = КлассификаторДоходовБюджетов2015.НайтиСтроки(Отбор);
	
	Если НайденныеСтроки.Количество() = 1 Тогда
		НазначениеПлатежаПоКБК = НайденныеСтроки[0].НазначениеПлатежа;
	КонецЕсли;
	
	Возврат НазначениеПлатежаПоКБК;
	
КонецФункции

// Возвращает назначение вид налога по КБК
//
// Параметры:
//    КБК - Строка - КБК
//
// Возвращаемое значение:
//    Строка - Вид налога
//
Функция ВидНалогаПоКБК(КБК) Экспорт
	
	ВидНалогаПоКБК = "";
	
	КлассификаторДоходовБюджетов2015 = КлассификаторДоходовБюджетов2015();
	
	Отбор = Новый Структура("Код", КБК);
	НайденныеСтроки = КлассификаторДоходовБюджетов2015.НайтиСтроки(Отбор);
	
	Если НайденныеСтроки.Количество() = 1 Тогда
		ВидНалогаПоКБК = НайденныеСтроки[0].Идентификатор;
	КонецЕсли;
	
	Возврат ВидНалогаПоКБК;
	
КонецФункции

// Возвращает вид налогового обязательства по КБК
//
// Параметры:
//    КБК - Строка - КБК
//    Период - Дата - Налоговый период.
//
// Возвращаемое значение:
//    Строка - Вид налогового обязательства.
//
Функция ВидНалоговогоОбязательстваПоКБК(КБК, Знач Период = Неопределено) Экспорт
	
	Если ПустаяСтрока(КБК) Тогда
		Возврат "Налог";
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Период) Тогда
		Период = ТекущаяДатаСеанса();
	КонецЕсли;
	
	КодПодвидаДоходов = ПлатежиВБюджетКлиентСервер.КодПодвидаДоходов(КБК);
	
	Если Лев(КодПодвидаДоходов, 1) = "3" Тогда
		
		ВидНалоговогоОбязательства = "Штраф";
		
	ИначеЕсли Лев(КодПодвидаДоходов, 2) = "22"
		И НачалоДня(Период) >= '20150101'
		И ПлатежиВБюджетКлиентСервер.ПлатежАдминистрируетсяНалоговымиОрганами(КБК) Тогда
		
		ВидНалоговогоОбязательства = "Проценты";
		
	ИначеЕсли Лев(КодПодвидаДоходов, 1) = "2" Тогда
		
		ВидНалоговогоОбязательства = "ПениСам";
		
	Иначе
		
		ВидНалоговогоОбязательства = "Налог";
		
	КонецЕсли;
	
	Возврат ВидНалоговогоОбязательства;
	
КонецФункции

// Возвращает признак прочей операции с точки зрения контролей 275-ФЗ
//
// Параметры:
//    ХозяйственнаяОперация - ПеречислениеСсылка.ХозяйственныеОперации - анализируемая хозяйственная операция.
//
// Возвращаемое значение:
//    Булево
//
Функция ПрочаяОперацияСписанияДСПо275ФЗ(ХозяйственнаяОперация) Экспорт
	ПрочаяОперацияСписанияДСПо275ФЗ = Истина;
	
	ХозяйственныеОперации = Перечисления.ХозяйственныеОперации;
	
	НеПрочиеОперации = Новый Массив;
	НеПрочиеОперации.Добавить(ХозяйственныеОперации.ОплатаПоставщику);
	НеПрочиеОперации.Добавить(ХозяйственныеОперации.ВозвратОплатыКлиенту);
	НеПрочиеОперации.Добавить(ХозяйственныеОперации.ПеречислениеВБюджет);
	НеПрочиеОперации.Добавить(ХозяйственныеОперации.ПеречислениеТаможне);
	НеПрочиеОперации.Добавить(ХозяйственныеОперации.ВнутренняяПередачаДенежныхСредств);
	НеПрочиеОперации.Добавить(ХозяйственныеОперации.ОплатаПоКредитам);
	НеПрочиеОперации.Добавить(ХозяйственныеОперации.ПеречислениеНаДепозиты);
	
	Если НеПрочиеОперации.Найти(ХозяйственнаяОперация) <> Неопределено Тогда
		ПрочаяОперацияСписанияДСПо275ФЗ = Ложь;
	КонецЕсли;
	
	Возврат ПрочаяОперацияСписанияДСПо275ФЗ;
КонецФункции

#Область ВыплатыСамозанятым

// Возвращает адрес сервиса ФНС с чеками
//
// Возвращаемое значение:
//   Строка - адрес страницы
//
Функция АдресСервисаФНС() Экспорт
	
	Возврат ДенежныеСредстваСерверЛокализация.АдресСервисаФНС();
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает значение основных реквизитов плательщика по организации и банковскому счету.
// 
// Параметры:
//  Организация - СправочникСсылка.Организации - организация плательщика.
//  БанковскийСчет - СправочникСсылка.БанковскиеСчетаОрганизаций - банковский счет плательщика.
// 
// Возвращаемое значение:
//  Структура - сведения о плательщике:
// * ИННПлательщика - Строка, Неопределено - ИНН
// * КПППлательщика - Строка, Неопределено - КПП
// * ТекстПлательщика - Строка, Неопределено - наименование плательщика в печатных документах.
//
Функция ДанныеПлательщика(Организация, БанковскийСчет) Экспорт
	
	Возврат ДенежныеСредстваСерверЛокализация.ДанныеПлательщика(Организация, БанковскийСчет);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Считывает таблицу классификатора доходов в бюджет
//
// Возвращаемое значение:
//    Структура - Структура с таблицей данных классификатора.
//
Функция КлассификаторДоходовБюджетов2015()
	
	Макет = ПолучитьОбщийМакет("КлассификаторДоходовБюджетов2015");
	Возврат ОбщегоНазначения.ПрочитатьXMLВТаблицу(Макет.ПолучитьТекст()).Данные;
	
КонецФункции

#КонецОбласти
