﻿
#Область ПрограммныйИнтерфейс    

#Область УстаревшиеПроцедурыИФункции

// Устарела: следует использовать ФорматноЛогическийКонтроль.ВыполненаПроверкаОбязательностиИПравильностиЗаполненияТэгов.
// Выполняет проверку обязательности заполняет тэгов
// 
// Параметры:
//  Параметры - Структура - Структура анализируемых параметров.
//  ИдентификаторУстройства - СправочникСсылка.ПодключаемоеОборудование - Устройство, фискализирующее чек
//  ОписаниеОшибки - Строка - описание ошибки для возврата в случае нахождения ошибки
//
// Возвращаемое значение:
//  Булево - Истина когда обязательные данные консистентны
Функция ВыполненаПроверкаОбязательностиИПравильностиЗаполненияТэгов(Параметры, ИдентификаторУстройства, ОписаниеОшибки) Экспорт
	
	Возврат ФорматноЛогическийКонтроль.ВыполненаПроверкаОбязательностиИПравильностиЗаполненияТэгов(Параметры, ИдентификаторУстройства, ОписаниеОшибки);
	
КонецФункции

// Устарела: следует использовать ФорматноЛогическийКонтроль.СтруктураДанныхФорматноЛогическогоКонтроля.
// Структура данных форматно-логического контроля
// 
// Параметры:
//  ПодключаемоеОборудование - СправочникСсылка.ПодключаемоеОборудование - Устройство, фискализирующее чек
// 
// Возвращаемое значение:
//  Структура - Структура данных форматно логического контроля:
//   * СпособФорматноЛогическогоКонтроля - Неопределено -
//   * ДопустимоеРасхождениеФорматноЛогическогоКонтроля - Число -
//   * ФорматФД - Строка -
//   * ФорматФД - Строка, Произвольный -
//
Функция СтруктураДанныхФорматноЛогическогоКонтроля(ПодключаемоеОборудование) Экспорт
	
	Возврат ФорматноЛогическийКонтроль.СтруктураДанныхФорматноЛогическогоКонтроля(ПодключаемоеОборудование);
	
КонецФункции

// Устарела: следует использовать ФорматноЛогическийКонтроль.ПривестиДанныеКТребуемомуФормату.
// Процедура приводит к формату согласованному с ФНС.
// Для старта преобразования данных нужно.
//
//  Параметры:
//    ОсновныеПараметры - см. ОборудованиеЧекопечатающиеУстройстваКлиентСервер.ПараметрыОперацииФискализацииЧека
//    Отказ - Булево
//    ОписаниеОшибки - Строка
//    ИсправленыОсновныеПараметры - Булево
//
Процедура ПривестиДанныеКТребуемомуФормату(ОсновныеПараметры, Отказ, ОписаниеОшибки, ИсправленыОсновныеПараметры) Экспорт
	
	ФорматноЛогическийКонтроль.ПривестиДанныеКТребуемомуФормату(ОсновныеПараметры, ИсправленыОсновныеПараметры);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс    

// Функция выполняет проверку сумм фискальных строк,
// осуществляя форматно-логический контроль чека.
// Функция переопределяется методом ФорматноЛогическийКонтрольПереопределяемый.ПровестиФорматноЛогическийКонтроль.
//
// Параметры:
//   ОбщиеПараметры - Структура - Полученная ранее методом ОборудованиеЧекопечатающиеУстройстваКлиентСервер.ПараметрыОперацииФискализацииЧека,
//                    и заполненная данными чека.
//                    Содержит параметры для контроля:
//                      СпособФорматноЛогическогоКонтроля - ПеречислениеСсылка.СпособыФорматноЛогическогоКонтроля - если не заполнена,
//                                                         то контроль не выполняется,
//                      ДопустимоеРасхождениеФорматноЛогическогоКонтроля - Число - по умолчанию установленное 54-ФЗ отклонение - 0.01.
//
//   ПодключаемоеОборудование - СправочникСсылка.ПодключаемоеОборудование - Не обязательный
//                              Если заполнено оборудование и не заполнен способ контроля в общих параметрах,
//                              то способ контроля и допустимое расхождение получаются из подключаемого оборудования.
//
Процедура ПровестиФорматноЛогическийКонтроль(ОбщиеПараметры, ПодключаемоеОборудование = Неопределено) Экспорт
	
	ФорматноЛогическийКонтроль.ПровестиФорматноЛогическийКонтроль(ОбщиеПараметры, ПодключаемоеОборудование);
	
КонецПроцедуры

// Функция выполняет проверку сумм фискальных строк,
// осуществляя форматно-логический контроль чека.
//
// Параметры:
//  ОбщиеПараметры - Структура
//
// Возвращаемое значение:
//  Булево
//
Функция НуженФорматноЛогическийКонтроль(ОбщиеПараметры) Экспорт
	
	Возврат ФорматноЛогическийКонтроль.НуженФорматноЛогическийКонтроль(ОбщиеПараметры);
	
КонецФункции

#КонецОбласти
